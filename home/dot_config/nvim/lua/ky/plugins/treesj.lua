return {
  'Wansmer/treesj',
  cmd = 'TSJToggle',
  keys = {
    { '<Leader>J', '<Cmd>TSJToggle<CR>', desc = 'Join/Split' },
  },
  config = function()
    require('treesj').setup({
      use_default_keymaps = false,
    })
  end,
}
