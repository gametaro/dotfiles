vim.keymap.set({ 'n', 'x' }, 's', '<Nop>')
vim.keymap.set({ 'n', 'x' }, 's', '<Cmd>Pounce<CR>')
vim.keymap.set({ 'n', 'x', 'o' }, 'S', '<Cmd>PounceRepeat<CR>')
vim.keymap.set('o', 'gs', '<Cmd>Pounce<CR>')
