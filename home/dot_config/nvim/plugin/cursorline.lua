local debounce_leading = require('ky.defer').debounce_leading
local debounce_trailing = require('ky.defer').debounce_trailing

local group = vim.api.nvim_create_augroup('mine__cursorline', {})

---@class number.Options
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

---@param buf integer
local ignore = function(buf)
  return vim.tbl_contains(opts.ignore_buftype, vim.bo[buf].buftype)
    or vim.tbl_contains(opts.ignore_filetype, vim.bo[buf].filetype)
end

---@param value boolean
local cursorline = function(value)
  if ignore(vim.api.nvim_get_current_buf()) then return end
  return vim.api.nvim_set_option_value('cursorline', value, { scope = 'local' })
end

local enable_cursorline = debounce_trailing(function()
  cursorline(true)
end, opts.timeout.enable)

local disable_cursorline = debounce_leading(function()
  cursorline(false)
end, opts.timeout.disable)

vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
  group = group,
  callback = function()
    cursorline(true)
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
    disable_cursorline()
    enable_cursorline()
  end,
})
