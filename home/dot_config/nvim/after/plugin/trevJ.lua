local ok = prequire('trevj')
if not ok then return end

vim.keymap.set('n', '<LocalLeader>j', function()
  require('trevj').format_at_cursor()
end)
require('trevj').setup()
