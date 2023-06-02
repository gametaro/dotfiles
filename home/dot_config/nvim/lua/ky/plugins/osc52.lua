return {
  'ojroques/nvim-osc52',
  init = function()
    vim.keymap.set('n', '<Leader>y', function()
      return require('osc52').copy_operator()
    end, { expr = true, desc = 'Yank (OSC52)' })
    vim.keymap.set('x', '<Leader>y', function()
      require('osc52').copy_visual()
    end, { desc = 'Yank (OSC52)' })
  end,
}
