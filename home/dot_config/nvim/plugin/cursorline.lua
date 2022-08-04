local group = vim.api.nvim_create_augroup('mine__cursorline', {})

---@param value boolean
---@return nil
local cursorline = function(value)
  return vim.api.nvim_set_option_value('cursorline', value, { scope = 'local' })
end

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

local disable_cursorline = require('ky.defer').debounce_leading(function()
  cursorline(false)
end, 300)

local enable_cursorline = require('ky.defer').debounce_trailing(function()
  cursorline(true)
end, 300)

vim.api.nvim_create_autocmd('CursorMoved', {
  group = group,
  callback = function()
    disable_cursorline()
    enable_cursorline()
  end,
})

-- vim.api.nvim_create_autocmd('CursorHold', {
--   group = group,
--   callback = function()
--     cursorline(true)
--   end,
-- })
