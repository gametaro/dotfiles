return {
  'ojroques/nvim-osc52',
  init = function()
    vim.keymap.set('n', '<Leader>y', function()
      return require('osc52').copy_operator()
    end, { expr = true })
    vim.keymap.set('x', '<Leader>y', function()
      require('osc52').copy_visual()
    end)
  end,
}
