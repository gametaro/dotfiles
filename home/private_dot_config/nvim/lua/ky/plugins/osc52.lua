return {
  'ojroques/nvim-osc52',
  init = function()
    vim.keymap.set('n', '<LocalLeader>y', function()
      return require('osc52').copy_operator()
    end, { expr = true })
    vim.keymap.set('x', '<LocalLeader>y', function()
      require('osc52').copy_visual()
    end)
  end,
}
