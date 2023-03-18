---@alias ls.Type 'file' | 'directory' | 'link'
---@alias ls.File { name: string, type: ls.Type }

local function is_win()
  return vim.loop.os_uname().sysname:lower():match('win') and true or false
end

local sep = is_win() and '\\' or '/'
local ns = vim.api.nvim_create_namespace('ls')

local bufs = {}

---@class ls.Config
local config = {
  hidden = false,
  icon = true,
  git_status = true,
  diagnostics = true,
  link = true,
  keepalt = false,
}

---@param s string
local function trim_sep(s)
  ---@type ls.Config
  return string.gsub(s, sep .. '$', '')
end

local function lock()
  vim.bo.modified = false
  -- vim.bo.modifiable = false
  -- vim.bo.readonly = true
end

local function unlock()
  vim.bo.filetype = 'ls'
  vim.bo.buftype = 'nofile'
  -- vim.bo.bufhidden = 'unload'
  vim.bo.modifiable = true
  vim.bo.buflisted = false
  vim.bo.swapfile = false
  vim.bo.readonly = false
end

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
    name = path .. sep .. name
    type = vim.loop.fs_lstat(name).type == 'link' and 'link' or type
    files[#files + 1] = { name = name, type = type }
  end
  return files
end

---@param lines string[]
local function set_lines(lines)
  unlock()
  vim.api.nvim_buf_set_lines(0, 0, -1, true, lines)
  lock()
end

---@param line string
---@param lnum integer
local function icons(line, lnum)
  local ok, devicons = pcall(require, 'nvim-web-devicons')
  if not ok then
    return
  end
  local icon, hl_group = devicons.get_icon(line, nil, { default = true })
  if vim.endswith(line, sep) then
    icon = ''
    hl_group = 'Directory'
  end
  vim.api.nvim_buf_set_extmark(0, ns, lnum, 0, {
    sign_text = icon,
    sign_hl_group = hl_group,
  })
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
---@param lnum integer
local function git_status(line, lnum)
  require('ky.util').job(
    'git',
    { '--no-optional-locks', 'status', '--porcelain', line },
    vim.schedule_wrap(function(_, data)
      if not data then
        return
      end
      local index = data:sub(1, 1)
      local worktree = data:sub(2, 2)
      vim.api.nvim_buf_set_extmark(0, ns, lnum, 0, {
        virt_text = { { index, status_to_hl(index) }, { worktree, status_to_hl(worktree) } },
        virt_text_pos = 'eol',
      })
    end)
  )
end

---@param line string
local function diagnostic(line, lnum)
  local get = vim.diagnostic.get
  local sign = vim.fn.sign_getdefined
  local severity = vim.diagnostic.severity
  if vim.fn.isdirectory(line) == 1 then
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

    if not text then
      return
    end

    vim.api.nvim_buf_set_extmark(0, ns, lnum, 0, {
      virt_text = { { text, hl } },
      virt_text_pos = 'eol',
    })
  end
end

---@param line string
---@param lnum integer
local function link(line, lnum)
  local realpath = vim.fn.fnamemodify(vim.loop.fs_realpath(line), ':.')
  local islink = trim_sep(line) ~= realpath
  if islink then
    vim.api.nvim_buf_set_extmark(0, ns, lnum, 0, {
      virt_text = { { '-> ' .. realpath, 'Directory' } },
      virt_text_pos = 'eol',
    })
  end
end

local function toggle_hidden()
  config.hidden = not config.hidden
  vim.cmd.edit()
end

---@param files ls.File[]
local function render(files)
  if vim.tbl_isempty(files) then
    set_lines({ '..' .. sep })
    return
  end
  local lines = vim.tbl_map(function(file)
    return vim.fn.fnamemodify(file.type == 'directory' and file.name .. sep or file.name, ':.')
  end, files)
  set_lines(lines)
end

local function detach(buf)
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
end

local function attach(buf)
  if bufs[buf] then
    return
  end
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  local ok = vim.api.nvim_buf_attach(buf, false, {
    on_lines = function(_, _, _, first, _, last)
      vim.schedule(function()
        local lines = vim.tbl_filter(function(line)
          return line ~= ''
        end, vim.api.nvim_buf_get_lines(buf, first, last, false))
        vim.api.nvim_buf_clear_namespace(buf, ns, first, last)
        for i, line in ipairs(lines) do
          local lnum = i + first - 1
          if config.diagnostics then
            diagnostic(line, lnum)
          end
          if config.icon then
            icons(line, lnum)
          end
          if config.git_status then
            git_status(line, lnum)
          end
          if config.link then
            link(line, lnum)
          end
        end
      end)
    end,
    on_detach = function()
      detach(buf)
    end,
  })
  if ok then
    bufs[buf] = buf
  end
end

local function init(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local dir = vim.fn.resolve(vim.fn.expand('%:p'))
  if vim.fn.isdirectory(dir) == 0 then
    return
  end
  attach(buf)
  local files = list(dir)
  if not config.hidden then
    files = vim.tbl_filter(function(file)
      return not vim.startswith(vim.fs.basename(file.name), '.')
    end, files)
  end
  table.sort(files, sort)
  render(files)
  vim.fn.search(
    string.format([[\v^\V%s]], vim.fn.escape(vim.fn.resolve(vim.fn.expand('#')), sep), 'c')
  )
end

---@param buf integer
local function set_mappings(buf)
  vim.keymap.set('n', '<CR>', 'gf', { buffer = buf })
  vim.keymap.set('n', '-', function()
    vim.cmd.edit('%:h')
  end, { buffer = buf })
  vim.keymap.set('n', '.', toggle_hidden, { buffer = buf })
end

local group = vim.api.nvim_create_augroup('ls', {})
vim.api.nvim_create_autocmd('FileType', {
  group = group,
  pattern = 'ls',
  callback = function(a)
    set_mappings(a.buf)
  end,
})
vim.api.nvim_create_autocmd('BufEnter', {
  group = group,
  callback = function(a)
    init(a.buf)
  end,
})
