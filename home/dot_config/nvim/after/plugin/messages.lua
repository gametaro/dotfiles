local ok = prequire('messages')
if not ok then
  return
end

require('messages').setup({
  border = require('ky.ui').border,
  post_open_float = function(winnr)
    local buffer = vim.api.nvim_win_get_buf(winnr)
    vim.keymap.set('n', 'q', '<C-w>c', { buffer = buffer, nowait = true })
  end,
})

Msg = function(...)
  require('messages.api').capture_thing(...)
end

local cabbrev = require('ky.abbrev').cabbrev
cabbrev('m', 'Messages')
cabbrev('lm', 'lua =Msg()<Left>')
