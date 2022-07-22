vim.keymap.set({ 'n', 'x' }, 's', '<Nop>')
vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Cmd>Pounce<CR>')
vim.keymap.set({ 'n', 'x', 'o' }, 'S', '<Cmd>PounceRepeat<CR>')

require('pounce').setup {}
