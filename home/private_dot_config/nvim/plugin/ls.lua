---@alias ls.File { name: string, type: uv.aliases.fs_stat_types }
---@alias ls.Provider fun(line: string, row: integer)

local ns = vim.api.nvim_create_namespace('ls')

---@type table<string, ls.Provider>
local providers = {}

---@param path string
---@return boolean
local function is_directory(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == 'directory' or false
end

---@param s? string
---@return boolean
local function is_empty(s)
  return s == nil or s == ''
end

---@param name string
---@return string
local function relative_path(name)
  return vim.fs.normalize(vim.fn.fnamemodify(name, ':.'))
end

local sep = '/'

---@type table<integer, boolean>
local bufs = {}

---@class ls.Config
local config = {
  debounce = 100,
  conceal = true,
  diagnostic = true,
  highlight = true,
  git_status = true,
  hidden = false,
  icon = true,
  link = true,
}

---@param a ls.File
---@param b ls.File
---@return boolean
local function sort(a, b)
  if a.type == 'directory' and b.type ~= 'directory' then
    return true
  elseif a.type ~= 'directory' and b.type == 'directory' then
    return false
  end
  return a.name < b.name
end

---@param ... unknown
---@return string
local function join_paths(...)
  return (table.concat({ ... }, '/'):gsub('//+', '/'))
end

---@param path string
---@param opts? table
---@return ls.File[]
local function list(path, opts)
  local files = {}
  for name, type in vim.fs.dir(path, opts) do
    name = join_paths(path, name)
    files[#files + 1] = { name = name, type = type }
  end
  return files
end

---@type ls.Provider
function providers.icon(line, row)
  local ok, devicons = pcall(require, 'nvim-web-devicons')
  if not ok then
    return
  end
  local icon, hl = devicons.get_icon(line, nil, { default = true })
  vim.loop.fs_stat(line, function(_, stat)
    if stat and stat.type == 'directory' then
      icon = ''
      hl = 'Directory'
    end
    vim.schedule(function()
      vim.api.nvim_buf_set_extmark(0, ns, row, 0, {
        sign_text = icon,
        sign_hl_group = hl,
      })
    end)
  end)
end

---@param status string
---@return string
local function status_to_hl(status)
  local map = {
    [' '] = 'Comment',
    ['!'] = 'Comment',
    ['?'] = 'Comment',
    ['A'] = 'DiffAdd',
    ['B'] = 'Error',
    ['C'] = 'Special',
    ['D'] = 'DiffDelete',
    ['M'] = 'DiffChange',
    ['R'] = 'Special',
    ['T'] = 'Special',
    ['U'] = 'Special',
    ['X'] = 'Special',
  }
  return map[status]
end

---@param path string
---@param opts { args: string[]?, cwd: string?, env: table<string, any>? }
---@param callback fun(code: integer, signal: integer, data: string)
---@return uv_process_t|nil
local function job(path, opts, callback)
  local handle
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)
  local results = {}

  ---@param pipe uv_pipe_t
  local function close(pipe)
    if pipe and not pipe:is_closing() then
      pipe:close()
    end
  end

  ---@param err string
  ---@param data string
  local function on_read(err, data)
    if data then
      results[#results + 1] = data
    end
  end

  ---@param code integer
  ---@param signal integer
  local function on_exit(code, signal)
    close(stdout)
    close(stderr)
    close(handle)

    vim.schedule(function()
      callback(code, signal, table.concat(results))
    end)
  end

  handle = vim.loop.spawn(path, {
    args = opts.args,
    cwd = opts.cwd,
    env = opts.env,
    stdio = { nil, stdout, stderr },
  }, vim.schedule_wrap(on_exit))

  if handle then
    if stdout then
      stdout:read_start(on_read)
    end
    if stderr then
      stderr:read_start(on_read)
    end
  else
    close(stdout)
    close(stderr)
  end

  return handle
end

---@type ls.Provider
function providers.git_status(line, row)
  job('git', {
    args = {
      '--no-optional-locks',
      'status',
      '--porcelain',
      '--ignored=matching',
      line,
    },
    cwd = vim.loop.cwd(),
  }, function(err, _, data)
    if err == 0 then
      local index = data:sub(1, 1)
      local worktree = data:sub(2, 2)
      vim.api.nvim_buf_set_extmark(0, ns, row, 0, {
        virt_text = { { index, status_to_hl(index) }, { worktree, status_to_hl(worktree) } },
        virt_text_pos = 'eol',
      })
    end
  end)
end

---@type ls.Provider
function providers.diagnostic(line, row)
  local get = vim.diagnostic.get
  local sign = vim.fn.sign_getdefined
  local severity = vim.diagnostic.severity
  if is_directory(line) then
    return
  end
  if vim.fn.bufexists(line) == 1 then
    local bufnr = vim.fn.bufnr(line)
    local hint = not vim.tbl_isempty(get(bufnr, { severity = severity.HINT }))
        and sign('DiagnosticSignHint')[1].text
      or nil
    local info = not vim.tbl_isempty(get(bufnr, { severity = severity.INFO }))
        and sign('DiagnosticSignInfo')[1].text
      or nil
    local warn = not vim.tbl_isempty(get(bufnr, { severity = severity.WARN }))
        and sign('DiagnosticSignWarn')[1].text
      or nil
    local error = not vim.tbl_isempty(get(bufnr, { severity = severity.ERROR }))
        and sign('DiagnosticSignError')[1].text
      or nil
    local text = error or warn or info or hint
    local hl = string.format(
      'Diagnostic%s',
      (error and 'Error') or (warn and 'Warn') or (info and 'Info') or (hint and 'Hint')
    )

    if not is_empty(text) then
      vim.api.nvim_buf_set_extmark(0, ns, row, 0, {
        virt_text = { { text, hl } },
        virt_text_pos = 'eol',
      })
    end
  end
end

---@type ls.Provider
function providers.link(line, row)
  vim.loop.fs_stat(line, function(_, stat)
    vim.loop.fs_readlink(line, function(_, _link)
      local hl = stat and 'Directory' or 'ErrorMsg'
      if _link then
        vim.schedule(function()
          vim.api.nvim_buf_set_extmark(0, ns, row, 0, {
            virt_text = { { '→ ' .. relative_path(_link), hl } },
            virt_text_pos = 'eol',
          })
        end)
      end
    end)
  end)
end

---@type ls.Provider
function providers.conceal(line, row)
  local path = relative_path(vim.api.nvim_buf_get_name(0))
  local _, end_col = line:find(path .. sep)
  if not end_col then
    return
  end

  vim.api.nvim_buf_set_extmark(0, ns, row, 0, {
    end_row = row,
    end_col = end_col,
    conceal = '',
  })
end

---@type ls.Provider
function providers.highlight(line, row)
  vim.loop.fs_stat(line, function(_, stat)
    if stat then
      if stat.type ~= 'directory' and require('bit').band(stat.mode, 73) > 0 then
        vim.schedule(function()
          vim.api.nvim_buf_set_extmark(0, ns, row, 0, {
            end_row = row,
            end_col = string.len(line),
            hl_group = 'Special',
          })
        end)
      end
      if stat.type == 'directory' then
        vim.schedule(function()
          vim.api.nvim_buf_set_extmark(0, ns, row, 0, {
            end_row = row,
            end_col = string.len(line),
            hl_group = 'Directory',
          })
        end)
      end
    end
  end)
end

local function toggle_hidden()
  config.hidden = not config.hidden
  vim.cmd.edit()
end

---@param lines string[]
---@param first integer
local function decorate(lines, first)
  for i, line in ipairs(lines) do
    local row = i - 1 + first
    for name, provider in pairs(providers) do
      if config[name] then
        provider(line, row)
      end
    end
  end
end

---@param path string
local function render(path)
  local files = list(path)
  if not config.hidden then
    files = vim.tbl_filter(function(file)
      return not vim.startswith(vim.fs.basename(file.name), '.')
    end, files)
  end
  table.sort(files, sort)
  local lines = vim.tbl_isempty(files) and { '..' .. sep }
    or vim.tbl_map(function(file)
      return relative_path(file.name)
    end, files)

  vim.bo.buflisted = false
  vim.bo.buftype = 'nofile'
  vim.bo.modifiable = true
  vim.bo.swapfile = false
  vim.api.nvim_buf_set_lines(0, 0, -1, true, lines)
  decorate(lines, 0)
  vim.bo.modified = false
end

---@param fn function
---@param timeout integer
---@return function
local function debounce_trailing(fn, timeout)
  local timer = vim.loop.new_timer()
  return function(...)
    local argv = { ... }
    local argc = select('#', ...)

    if timer then
      timer:start(timeout, 0, function()
        timer:stop()
        pcall(vim.schedule_wrap(fn), unpack(argv, 1, argc))
      end)
    end
  end
end

local debounced_decorate = debounce_trailing(function(buf, first, last_old, last_new)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  local last = last_old > last_new and last_old or last_new
  vim.api.nvim_buf_clear_namespace(buf, ns, first, last)
  local lines = vim.tbl_filter(function(line)
    return line ~= ''
  end, vim.api.nvim_buf_get_lines(buf, first, last, false))
  decorate(lines, first)
end, config.debounce)

---@param buf integer
local function attach(buf)
  if bufs[buf] then
    return
  end
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  local ok = vim.api.nvim_buf_attach(buf, false, {
    on_lines = function(_, _, _, first, last_old, last_new, byte_count)
      if not bufs[buf] then
        return true
      end
      -- ignore a second undo events which indicates no changes.
      if first == last_old and last_old == last_new and byte_count == 0 then
        return
      end
      debounced_decorate(buf, first, last_old, last_new)
    end,
    on_detach = function()
      vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
      bufs[buf] = false
    end,
  })
  if ok then
    bufs[buf] = true
  end
end

local function set_cursor()
  local alt = relative_path(vim.fn.expand('#'))
  vim.fn.search(string.format([[\v^\V%s\v$]], vim.fn.escape(alt, sep)), 'c')
end

local function init()
  local path = vim.fs.normalize(vim.api.nvim_buf_get_name(0))
  if is_empty(path) then
    return
  end
  if not is_directory(path) then
    return
  end
  render(path)
  if vim.bo.filetype ~= 'ls' then
    vim.bo.filetype = 'ls'
  end
  set_cursor()
end

local function set_options()
  vim.opt_local.cursorline = true
  vim.opt_local.wrap = false
  vim.opt_local.isfname:append('32')
  if config.conceal then
    vim.opt_local.conceallevel = 2
    vim.opt_local.concealcursor = 'nc'
  end
end

---@param buf integer
local function set_mappings(buf)
  vim.keymap.set('n', '<CR>', 'gf', { buffer = buf })
  vim.keymap.set('n', '-', function()
    vim.cmd.edit('%:h')
  end, { buffer = buf })
  vim.keymap.set('n', '<Leader>.', toggle_hidden, { buffer = buf })
  vim.keymap.set('n', 'q', '<Cmd>bdelete!<CR>', { buffer = buf, nowait = true })
  vim.keymap.set('n', '<Esc>', '<Cmd>bdelete!<CR>', { buffer = buf })
end

local group = vim.api.nvim_create_augroup('ls', {})
vim.api.nvim_create_autocmd('FileType', {
  group = group,
  pattern = 'ls',
  callback = function(a)
    set_options()
    set_mappings(a.buf)
    attach(a.buf)
  end,
})
vim.api.nvim_create_autocmd('BufEnter', {
  group = group,
  callback = init,
})
