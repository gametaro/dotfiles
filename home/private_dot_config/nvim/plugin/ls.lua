---@alias ls.File { name: string, type: uv.aliases.fs_stat_types }
---@alias ls.Decorator fun(buf: integer, line: string, row: integer)

local ok, devicons = pcall(require, 'nvim-web-devicons')

local ns = vim.api.nvim_create_namespace('ls')

---@type table<integer, boolean|nil>
local bufs = {}

---@type table<integer, table<string, boolean|nil>>
local cache = vim.defaulttable()

---@type table<string, ls.Decorator>
local decorators = {}

---@param buf integer
---@param row integer
---@param opts table<string, any>
local function set_extmark(buf, row, opts)
  vim.api.nvim_buf_set_extmark(buf, ns, row, 0, opts)
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
  icon = ok,
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
  return vim.iter(vim.fs.dir(path, opts)):fold({}, function(acc, name, type)
    acc[#acc + 1] = { name = join_paths(path, name), type = type }
    return acc
  end)
end

---@type ls.Decorator
function decorators.icon(buf, line, row)
  local icon, hl = devicons.get_icon(line, nil, { default = true })
  vim.loop.fs_stat(line, function(_, stat)
    if stat and stat.type == 'directory' then
      icon = ''
      hl = 'Directory'
    end
    vim.schedule(function()
      set_extmark(buf, row, {
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
      set_extmark(buf, row, {
        virt_text = { { index, status_to_hl(index) }, { worktree, status_to_hl(worktree) } },
        virt_text_pos = 'eol',
      })
    end
  end)
end

local diag_signs = {
  hint = vim.fn.sign_getdefined('DiagnosticSignHint')[1].text,
  info = vim.fn.sign_getdefined('DiagnosticSignInfo')[1].text,
  warn = vim.fn.sign_getdefined('DiagnosticSignWarn')[1].text,
  error = vim.fn.sign_getdefined('DiagnosticSignError')[1].text,
}

---@type ls.Decorator
function decorators.diagnostic(buf, line, row)
  if vim.fn.isdirectory(line) == 1 then
    return
  end
  local bufnr = vim.fn.bufnr(line)
  if bufnr == -1 then
    return
  end

  local get = vim.diagnostic.get
  local severity = vim.diagnostic.severity
  local hint = not vim.tbl_isempty(get(bufnr, { severity = severity.HINT })) and diag_signs.hint
    or nil
  local info = not vim.tbl_isempty(get(bufnr, { severity = severity.INFO })) and diag_signs.info
    or nil
  local warn = not vim.tbl_isempty(get(bufnr, { severity = severity.WARN })) and diag_signs.warn
    or nil
  local error = not vim.tbl_isempty(get(bufnr, { severity = severity.ERROR })) and diag_signs.error
    or nil
  local text = error or warn or info or hint
  local hl = string.format(
    'Diagnostic%s',
    (error and 'Error') or (warn and 'Warn') or (info and 'Info') or (hint and 'Hint')
  )

  if not is_empty(text) then
    set_extmark(buf, row, {
      virt_text = { { text, hl } },
      virt_text_pos = 'eol',
    })
  end
end

---@type ls.Decorator
function decorators.conceal(buf, line, row)
  local path = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))
  local _, end_col = line:find(vim.pesc(path .. sep))
  if not end_col then
    return
  end

  set_extmark(buf, row, {
    end_row = row,
    end_col = end_col,
    conceal = '',
  })
end

---@type ls.Decorator
function decorators.highlight(buf, line, row)
  vim.loop.fs_lstat(line, function(_, stat)
    local end_col = string.len(line)
    local hl_group ---@type string?
    local virt_text_hl ---@type string?
    local link ---@type string?
    if stat then
      if stat.type == 'socket' then
        hl_group = 'String'
      elseif stat.type == 'directory' then
        -- sticky bit
        hl_group = require('bit').band(stat.mode, tonumber('1000', 8)) ~= 0 and 'Statement'
          or 'Directory'
      elseif stat.type == 'fifo' then
        hl_group = 'Type'
      elseif stat.type == 'char' then
        hl_group = 'PreProc'
      elseif stat.type == 'block' then
        hl_group = 'Constant'
      elseif stat.type == 'link' then
        hl_group = 'Identifier'
        link = vim.loop.fs_readlink(line)
        virt_text_hl = vim.loop.fs_stat(line) and 'Directory' or 'ErrorMsg'
        -- executable
      elseif require('bit').band(stat.mode, tonumber('111', 8)) ~= 0 then
        hl_group = 'Special'
      else
        hl_group = 'Normal'
      end
    else
      hl_group = 'Comment'
    end
    local opts = vim.tbl_extend('keep', {
      end_row = row,
      end_col = end_col,
      hl_group = hl_group,
    }, link and {
      virt_text = { { string.format('→ %s', link), virt_text_hl } },
      virt_text_pos = 'eol',
    } or {})
    vim.schedule(function()
      set_extmark(buf, row, opts)
    end)
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
    files = vim.filter(function(file)
      return not vim.startswith(vim.fs.basename(file.name), '.')
    end, files)
  end
  table.sort(files, sort)
  local lines = vim.tbl_isempty(files) and { '..' }
    or vim.map(function(file)
      return file.name
    end, files)

  vim.bo[buf].buflisted = false
  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].modifiable = true
  vim.bo[buf].swapfile = false
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, lines)
  vim.bo[buf].modified = false
end

local function set_cursor()
  local alt = vim.fn.expand('#')
  if is_empty(alt) then
    return
  end
  if vim.loop.fs_realpath(alt) then
    alt = vim.fs.normalize(vim.loop.fs_realpath(alt))
  end
  vim.fn.search(string.format([[\v^\V%s\v$]], vim.fn.escape(alt, sep)), 'c')
end

---@param buf integer
local function init(buf)
  local path = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))
  if is_empty(path) then
    return
  end
  if vim.fn.isdirectory(path) == 0 then
    return
  end
  render(buf, path)
  vim.bo[buf].filetype = 'ls'
  set_cursor()
end

---@param buf integer
local function set_options(buf)
  local function set_option(name, value)
    vim.api.nvim_set_option_value(name, value, { win = vim.fn.bufwinid(buf), scope = 'local' })
  end
  set_option('cursorline', true)
  set_option('wrap', false)
  set_option('isfname', vim.o.isfname .. ',32')
  set_option('cursorline', true)
  if config.conceal then
    set_option('conceallevel', 2)
    set_option('concealcursor', 'nc')
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

---@param buf integer
local function attach(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  if bufs[buf] then
    return
  end
  bufs[buf] = vim.api.nvim_buf_attach(buf, false, {
    on_lines = function(_, _, _, first, last_old, last_new, byte_count)
      -- ignore a second undo event which indicates no changes
      if first == last_old and last_old == last_new and byte_count == 0 then
        return
      end
      local last = last_old > last_new and last_old or last_new
      vim.api.nvim_buf_clear_namespace(buf, ns, first, last)
      local lines = vim.api.nvim_buf_get_lines(buf, first, last, false)
      vim.iter(lines):each(function(line)
        cache[buf][line] = nil
      end)
    end,
    on_detach = function()
      cache[buf] = nil
      bufs[buf] = nil
    end,
  })
end

local group = vim.api.nvim_create_augroup('ls', {})
vim.api.nvim_create_autocmd('FileType', {
  group = group,
  pattern = 'ls',
  callback = function(a)
    local buf = a.buf
    set_options(buf)
    set_mappings(buf)
    attach(buf)
  end,
})
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = group,
  callback = function(a)
    init(a.buf)
  end,
})

vim.api.nvim_set_decoration_provider(ns, {
  on_win = function(_, _, buf, top, bot)
    if vim.bo[buf].filetype ~= 'ls' then
      return false
    end
    for i = top, bot - 2 do
      local line = vim.api.nvim_buf_get_lines(buf, i, i + 1, false)[1]
      if line and not rawget(cache[buf], line) then
        vim.iter(decorators):each(function(name, decorator)
          if config[name] then
            decorator(buf, line, i)
          end
        end)
        cache[buf][line] = true
      end
    end
  end,
})
