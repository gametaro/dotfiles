return {
  'mbbill/undotree',
  cmd = 'UndotreeToggle',
  keys = {
    { '<Leader>u', vim.cmd.UndotreeToggle, desc = 'Undotree' },
  },
  init = function()
    vim.g.undotree_SetFocusWhenToggle = 1
    vim.g.undotree_SplitWidth = 40
    vim.g.undotree_WindowLayout = 2
  end,
}
