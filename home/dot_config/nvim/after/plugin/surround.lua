local ok = prequire('nvim-surround')
if not ok then return end

require('nvim-surround').setup {
  move_cursor = false,
}
