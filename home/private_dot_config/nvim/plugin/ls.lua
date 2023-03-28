---@alias ls.File { name: string, type: uv.aliases.fs_stat_types }
---@alias ls.Decorator fun(buf: integer, line: string, row: integer)

local ns = vim.api.nvim_create_namespace('ls')

---@type table<string, ls.Decorator>
local decorators = {}

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

local sep = '/'

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

---@param ... string
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

---@type ls.Decorator
function decorators.icon(buf, line, row)
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
      vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
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

---@type ls.Decorator
function decorators.git_status(buf, line, row)
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
      vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
        virt_text = { { index, status_to_hl(index) }, { worktree, status_to_hl(worktree) } },
        virt_text_pos = 'eol',
      })
    end
  end)
end

---@type ls.Decorator
function decorators.diagnostic(buf, line, row)
  if is_directory(line) then
    return
  end
  if vim.fn.bufexists(line) == 0 then
    return
  end

  local get = vim.diagnostic.get
  local sign = vim.fn.sign_getdefined
  local severity = vim.diagnostic.severity
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
    vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
      virt_text = { { text, hl } },
      virt_text_pos = 'eol',
    })
  end
end

---@type ls.Decorator
function decorators.link(buf, line, row)
  vim.loop.fs_stat(line, function(_, stat)
    vim.loop.fs_readlink(line, function(_, link)
      local hl = stat and 'Directory' or 'ErrorMsg'
      if link then
        vim.schedule(function()
          vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
            virt_text = { { '→ ' .. link, hl } },
            virt_text_pos = 'eol',
          })
        end)
      end
    end)
  end)
end

---@type ls.Decorator
function decorators.conceal(buf, line, row)
  local path = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))
  local _, end_col = line:find(vim.pesc(path .. sep))
  if not end_col then
    return
  end

  vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
    end_row = row,
    end_col = end_col,
    conceal = '',
  })
end

---@type ls.Decorator
function decorators.highlight(buf, line, row)
  vim.loop.fs_lstat(line, function(_, stat)
    if stat then
      if stat.type ~= 'directory' and require('bit').band(stat.mode, 73) > 0 then
        vim.schedule(function()
          vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
            end_row = row,
            end_col = string.len(line),
            hl_group = 'Special',
          })
        end)
      end
      if stat.type == 'directory' then
        vim.schedule(function()
          vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
            end_row = row,
            end_col = string.len(line),
            hl_group = 'Directory',
          })
        end)
      end
      if stat.type == 'link' then
        vim.schedule(function()
          vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
            end_row = row,
            end_col = string.len(line),
            hl_group = 'Identifier',
          })
        end)
      end
    else
      vim.schedule(function()
        vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
          end_row = row,
          end_col = string.len(line),
          hl_group = 'Comment',
        })
      end)
    end
  end)
end

local function toggle_hidden()
  config.hidden = not config.hidden
  vim.cmd.edit()
end

---@param buf integer
---@param path string
local function render(buf, path)
  local files = list(path)
  if not config.hidden then
    files = vim.tbl_filter(function(file)
      return not vim.startswith(vim.fs.basename(file.name), '.')
    end, files)
  end
  table.sort(files, sort)
  local lines = vim.tbl_isempty(files) and { '..' }
    or vim.tbl_map(function(file)
      return file.name
    end, files)

  vim.bo[buf].buflisted = false
  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].modifiable = true
  vim.bo[buf].swapfile = false
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, lines)
  vim.bo[buf].modified = false
end

---@param buf integer
local function attach(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  vim.api.nvim_set_decoration_provider(ns, {
    on_start = function()
      if vim.bo.filetype ~= 'ls' then
        return false
      end
    end,
    on_buf = function(_, bufnr, _)
      if vim.bo[bufnr].filetype ~= 'ls' then
        return
      end
      for _, mark in ipairs(vim.api.nvim_buf_get_extmarks(bufnr, ns, 0, -1, {})) do
        vim.api.nvim_buf_del_extmark(bufnr, ns, mark[1])
      end
      for i, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, true)) do
        for name, decorator in pairs(decorators) do
          if config[name] then
            decorator(bufnr, line, i - 1)
          end
        end
      end
    end,
    on_win = function()
      return false
    end,
  })
end

local function set_cursor()
  local alt = vim.fs.normalize(vim.loop.fs_realpath(vim.fn.expand('#')))
  vim.fn.search(string.format([[\v^\V%s\v$]], vim.fn.escape(alt, sep)), 'c')
end

---@param buf integer
local function init(buf)
  local path = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))
  if is_empty(path) then
    return
  end
  if not is_directory(path) then
    return
  end
  render(buf, path)
  if vim.bo[buf].filetype ~= 'ls' then
    vim.bo[buf].filetype = 'ls'
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
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = group,
  callback = function(a)
    init(a.buf)
  end,
})
