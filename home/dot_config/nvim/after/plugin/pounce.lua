vim.keymap.set({ 'n', 'x' }, 's', '<Nop>')
vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Cmd>Pounce<CR>')
vim.keymap.set({ 'n', 'x', 'o' }, 'S', '<Cmd>PounceRepeat<CR>')

vim.api.nvim_create_autocmd('User', {
  pattern = 'JetpackVimPouncePost',
  callback = function()
    require('pounce').setup {}
  end,
})
