local ok = prequire('tsht')
if not ok then return end

vim.keymap.set('o', 'm', ':<C-u>lua require("tsht").nodes()<CR>')
vim.keymap.set('x', 'm', ':lua require("tsht").nodes()<CR>')

require('tsht').config.hint_keys = { 'h', 'j', 'f', 'd', 'n', 'v', 's', 'l', 'a' }
