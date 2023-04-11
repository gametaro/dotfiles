return {
  'rlane/pounce.nvim',
  cmd = 'Pounce',
  init = function()
    vim.keymap.set({ 'n', 'x' }, 's', '')
    vim.keymap.set({ 'n', 'x' }, 's', '<Cmd>Pounce<CR>')
    vim.keymap.set({ 'n', 'x' }, '<Leader>s', '<Cmd>PounceCword<CR>')
    vim.keymap.set({ 'n', 'x', 'o' }, 'S', '<Cmd>PounceRepeat<CR>')
    vim.keymap.set('o', 'gs', '<Cmd>Pounce<CR>')
  end,
}
