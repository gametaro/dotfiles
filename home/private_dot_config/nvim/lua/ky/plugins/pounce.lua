return {
  'gametaro/pounce.nvim',
  branch = 'cword',
  cmd = 'Pounce',
  init = function()
    vim.keymap.set({ 'n', 'x' }, 's', '')
    vim.keymap.set({ 'n', 'x' }, 's', vim.cmd.Pounce)
    vim.keymap.set({ 'n', 'x' }, '<LocalLeader>s', vim.cmd.PounceCword)
    vim.keymap.set({ 'n', 'x', 'o' }, 'S', vim.cmd.PounceRepeat)
    vim.keymap.set('o', 'gs', vim.cmd.Pounce)
  end,
}
