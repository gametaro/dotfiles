local debounce_leading = require('ky.defer').debounce_leading
local debounce_trailing = require('ky.defer').debounce_trailing

local group = vim.api.nvim_create_augroup('CursorLine', {})

---@class cursorline.Options
---@field timeout table
---@field ignore_buftype string[]
---@field ignore_filetype string[]
local opts = {
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

---@param value boolean
local function cursorline(value)
  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  if
    vim.tbl_contains(opts.ignore_buftype, vim.bo[buf].buftype)
    or vim.tbl_contains(opts.ignore_filetype, vim.bo[buf].filetype)
  then
    return
  end
  return vim.api.nvim_set_option_value('cursorline', value, { scope = 'local', win = win })
end

local enable_cursorline = debounce_trailing(function()
  cursorline(true)
end, opts.timeout.enable)

local disable_cursorline = debounce_leading(function()
  cursorline(false)
end, opts.timeout.disable)

vim.api.nvim_create_autocmd({ 'InsertLeave', 'WinEnter' }, {
  group = group,
  callback = function()
    cursorline(true)
    vim.b.cursorline_disable_defer = true
  end,
})

vim.api.nvim_create_autocmd({ 'InsertEnter', 'WinLeave' }, {
  group = group,
  callback = function()
    cursorline(false)
  end,
})

vim.api.nvim_create_autocmd('CursorMoved', {
  group = group,
  callback = function()
    local lnum = vim.fn.line('.')
    if not vim.b.cursorline_lnum then
      vim.b.cursorline_lnum = lnum
    end
    if vim.b.cursorline_lnum ~= lnum and not vim.b.cursorline_disable_defer then
      vim.b.cursorline_lnum = lnum
      disable_cursorline()
      enable_cursorline()
    end
    vim.b.cursorline_disable_defer = false
  end,
})
