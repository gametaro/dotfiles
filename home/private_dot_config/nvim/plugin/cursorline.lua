local debounce_leading = require('ky.defer').debounce_leading
local debounce_trailing = require('ky.defer').debounce_trailing

local group = vim.api.nvim_create_augroup('Cursor', {})

---@class cursorline.Options
---@field cursorline boolean
---@field cursorcolumn boolean
---@field timeout { enable: integer, disable: integer }
---@field ignore_buftype string[]
---@field ignore_filetype string[]
local opts = {
  cursorline = true,
  cursorcolumn = true,
  timeout = {
    enable = 300,
    disable = 300,
  },
  ignore_buftype = {
    'nofile',
    'prompt',
  },
  ignore_filetype = {
    'TelescopePrompt',
  },
}

local function set(option, value)
  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  if
    vim.tbl_contains(opts.ignore_buftype, vim.bo[buf].buftype)
    or vim.tbl_contains(opts.ignore_filetype, vim.bo[buf].filetype)
  then
    return
  end
  vim.api.nvim_set_option_value(option, value, { scope = 'local', win = win })
end

---@param value boolean
local function cursorline(value)
  set('cursorline', value)
end

---@param value boolean
local function cursorcolumn(value)
  set('cursorcolumn', value)
end

local enable_cursorline = debounce_trailing(function()
  cursorline(true)
end, opts.timeout.enable)

local disable_cursorline = debounce_leading(function()
  cursorline(false)
end, opts.timeout.disable)

local enable_cursorcolumn = debounce_trailing(function()
  cursorcolumn(true)
end, opts.timeout.enable)

local disable_cursorcolumn = debounce_leading(function()
  cursorcolumn(false)
end, opts.timeout.disable)

local function on_cursor_moved()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.b.cursor_pos = vim.b.cursor_pos or {}
  vim.b.cursor_pos = { vim.b.cursor_pos[1] or row, vim.b.cursor_pos[2] or col }

  local cursor_pos = vim.b.cursor_pos
  if opts.cursorline and cursor_pos[1] ~= row and not vim.b.cursorline_disable_defer then
    cursor_pos[1] = row
    disable_cursorline()
    enable_cursorline()
  end
  if opts.cursorcolumn and cursor_pos[2] ~= col and not vim.b.cursorcolumn_disable_defer then
    cursor_pos[2] = col
    disable_cursorcolumn()
    enable_cursorcolumn()
  end
  vim.b.cursor_pos = cursor_pos
  if opts.cursorline then
    vim.b.cursorline_disable_defer = false
  end
  if opts.cursorcolumn then
    vim.b.cursorcolumn_disable_defer = false
  end
end

vim.api.nvim_create_autocmd({ 'InsertLeave', 'WinEnter' }, {
  group = group,
  callback = function()
    if opts.cursorline then
      cursorline(opts.cursorline)
      vim.b.cursorline_disable_defer = true
    end
    if opts.cursorcolumn then
      cursorcolumn(opts.cursorcolumn)
      vim.b.cursorcolumn_disable_defer = true
    end
  end,
})

vim.api.nvim_create_autocmd({ 'InsertEnter', 'WinLeave' }, {
  group = group,
  callback = function()
    if opts.cursorline then
      cursorline(false)
    end
    if opts.cursorcolumn then
      cursorcolumn(false)
    end
  end,
})

vim.api.nvim_create_autocmd('CursorMoved', {
  group = group,
  callback = on_cursor_moved,
})
