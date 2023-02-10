return {
  'Wansmer/treesj',
  cmd = 'TSJToggle',
  keys = {
    { '<Leader>j', vim.cmd.TSJToggle },
  },
  config = function()
    require('treesj').setup({
      use_default_keymaps = false,
    })
  end,
}
