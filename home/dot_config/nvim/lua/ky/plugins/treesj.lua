return {
  'Wansmer/treesj',
  cmd = 'TSJToggle',
  init = function()
    vim.keymap.set('n', '<LocalLeader>j', vim.cmd.TSJToggle)
  end,
  config = function()
    require('treesj').setup({
      use_default_keymaps = false,
    })
  end,
}
