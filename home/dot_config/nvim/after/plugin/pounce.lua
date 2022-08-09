vim.keymap.set({ 'n', 'x' }, 's', '<Nop>')
vim.keymap.set({ 'n', 'x' }, 's', '<Cmd>Pounce<CR>')
vim.keymap.set({ 'n', 'x', 'o' }, 'S', '<Cmd>PounceRepeat<CR>')
vim.keymap.set('o', 'gs', '<Cmd>Pounce<CR>')

vim.api.nvim_create_autocmd('User', {
  pattern = 'JetpackPounceNvimPost',
  callback = function()
    require('pounce').setup {}
  end,
})
