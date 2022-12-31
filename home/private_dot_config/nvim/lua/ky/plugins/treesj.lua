return {
  'Wansmer/treesj',
  cmd = 'TSJToggle',
  keys = {
    { '<LocalLeader>j', vim.cmd.TSJToggle },
  },
  config = function()
    require('treesj').setup({
      use_default_keymaps = false,
    })
  end,
}
