local ok = prequire('messages')
if not ok then
  return
end

require('messages').setup({
  --  TODO: Not work?
  post_open_float = function(winnr)
    local buffer = vim.api.nvim_win_get_buf(winnr)
    vim.keymap.set('n', 'q', '<C-w>c', { buffer = buffer, nowait = true })
  end,
})

Msg = function(...)
  require('messages.api').capture_thing(...)
end
