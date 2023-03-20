---@alias ls.Type 'file' | 'directory' | 'link'
---@alias ls.File { name: string, type: ls.Type }

local ns = vim.api.nvim_create_namespace('ls')

local function is_win()
  return vim.loop.os_uname().sysname:lower():match('win') and true or false
end

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
  return vim.fn.fnamemodify(name, ':.')
end

local sep = is_win() and '\\' or '/'

---@type integer[]
local bufs = {}

---@class ls.Config
local config = {
  conceal = true,
  diagnostics = true,
  highlight = true,
  git_status = true,
  hidden = false,
  icons = true,
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

---@param path string
---@param opts? table
---@return ls.File[]
local function list(path, opts)
  local files = {}
  for name, type in vim.fs.dir(path, opts) do
    if not is_empty(name) and not is_empty(type) then
      name = path == sep and path .. name or path .. sep .. name
      files[#files + 1] = { name = name, type = type }
    end
  end
  return files
end

---@param line string
---@param row integer
local function icons(line, row)
  local ok, devicons = pcall(require, 'nvim-web-devicons')
  if not ok then
    return
  end
  local icon, hl_group = devicons.get_icon(line, nil, { default = true })
  vim.loop.fs_stat(line, function(_, stat)
    if stat and stat.type == 'directory' then
      icon = ''
      hl_group = 'Directory'
    end
    vim.schedule(function()
      vim.api.nvim_buf_set_extmark(0, ns, row, 0, {
        sign_text = icon,
        sign_hl_group = hl_group,
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

---@param line string
---@param row integer
local function git_status(line, row)
  -- TODO: should respect cwd?
  require('ky.util').job(
    'git',
    { '--no-optional-locks', 'status', '--porcelain', '--ignored', line },
    vim.schedule_wrap(function(_, data)
      if not is_empty(data) then
        local index = data:sub(1, 1)
        local worktree = data:sub(2, 2)
        vim.api.nvim_buf_set_extmark(0, ns, row, 0, {
          virt_text = { { index, status_to_hl(index) }, { worktree, status_to_hl(worktree) } },
          virt_text_pos = 'eol',
        })
      end
    end)
  )
end

---@param line string
---@param row integer
local function diagnostic(line, row)
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

---@param line string
---@param row integer
local function link(line, row)
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

---@param line string
---@param row integer
local function conceal(line, row)
  local path = relative_path(vim.api.nvim_buf_get_name(0))
  local _, end_ = line:find(path .. sep)
  if not end_ then
    return
  end

  vim.api.nvim_buf_set_extmark(0, ns, row, 0, {
    end_row = row,
    end_col = end_,
    conceal = '',
    priority = 1000,
  })
end

---@param line string
---@param row integer
local function highlight(line, row)
  vim.loop.fs_stat(line, function(_, stat)
    if stat then
      -- TODO: should be done by luv?
      if stat.type ~= 'directory' and vim.fn.getfperm(line):match('x', 3) then
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

---@param file ls.File
local function normalize(file)
  local name = relative_path(file.name)
  return file.type == 'directory' and name .. sep or name
end

---@param files ls.File[]
local function render(files)
  local lines = vim.tbl_isempty(files) and { '..' .. sep } or vim.tbl_map(normalize, files)

  vim.bo.buflisted = false
  vim.bo.buftype = 'nofile'
  vim.bo.modifiable = true
  vim.bo.swapfile = false
  vim.api.nvim_buf_set_lines(0, 0, -1, true, lines)
  for i, line in ipairs(lines) do
    conceal(line, i - 1)
  end
  vim.bo.modified = false
end

---@param buf integer
---@param first integer
---@param last integer
local function decorate(buf, first, last)
  ---@type string[]
  local lines = vim.tbl_filter(function(line)
    return line ~= ''
  end, vim.api.nvim_buf_get_lines(buf, first, last, false))
  if vim.tbl_isempty(lines) then
    return
  end

  vim.api.nvim_buf_clear_namespace(buf, ns, first, last)

  for i, line in ipairs(lines) do
    local row = i + first - 1
    if config.conceal then
      conceal(line, row)
    end
    if config.highlight then
      highlight(line, row)
    end
    if config.diagnostics then
      diagnostic(line, row)
    end
    if config.icons then
      icons(line, row)
    end
    if config.git_status then
      git_status(line, row)
    end
    if config.link then
      link(line, row)
    end
  end
end

local function attach(buf)
  if bufs[buf] then
    return
  end
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  bufs[buf] = buf

  vim.api.nvim_buf_attach(buf, false, {
    on_lines = function(_, _, _, first, _, last)
      if not bufs[buf] then
        return true
      end
      vim.schedule(function()
        decorate(buf, first, last + 1)
      end)
    end,
    on_detach = function()
      vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
      bufs[buf] = nil
    end,
  })
end

local function init()
  local path = vim.loop.fs_realpath(vim.api.nvim_buf_get_name(0))
  if is_empty(path) then
    return
  end
  if not is_directory(path) then
    return
  end
  vim.bo.filetype = 'ls'
  local files = list(path)
  if not config.hidden then
    files = vim.tbl_filter(function(file)
      return not vim.startswith(vim.fs.basename(file.name), '.')
    end, files)
  end
  table.sort(files, sort)
  render(files)
  local alt = relative_path(vim.fn.expand('#'))
  if is_directory(alt) then
    alt = alt .. sep
  end
  vim.fn.search(string.format([[\v^\V%s\v$]], vim.fn.escape(alt, sep)), 'c')
end

---@param buf integer
local function set_mappings(buf)
  vim.keymap.set('n', '<CR>', 'gf', { buffer = buf })
  vim.keymap.set('n', '-', function()
    vim.cmd.edit('%:h')
  end, { buffer = buf })
  vim.keymap.set('n', '.', toggle_hidden, { buffer = buf })
  vim.keymap.set('n', 'q', '<Cmd>bdelete!<CR>', { buffer = buf, nowait = true })
  vim.keymap.set('n', '<Esc>', '<Cmd>bdelete!<CR>', { buffer = buf })
end

local group = vim.api.nvim_create_augroup('ls', {})
vim.api.nvim_create_autocmd('FileType', {
  group = group,
  pattern = 'ls',
  callback = function(a)
    vim.opt_local.cursorline = true
    vim.opt_local.wrap = false
    if config.conceal then
      vim.opt_local.conceallevel = 2
      vim.opt_local.concealcursor = 'nc'
    end
    attach(a.buf)
    set_mappings(a.buf)
  end,
})
vim.api.nvim_create_autocmd('BufEnter', {
  group = group,
  callback = init,
})
