vim.g.swap_no_default_key_mappings = 1

vim.keymap.set('n', 'g<', '<Plug>(swap-prev)')
vim.keymap.set('n', 'g>', '<Plug>(swap-next)')
vim.keymap.set({ 'o', 'x' }, 'i,', '<Plug>(swap-textobject-i)')
vim.keymap.set({ 'o', 'x' }, 'a,', '<Plug>(swap-textobject-a)')
