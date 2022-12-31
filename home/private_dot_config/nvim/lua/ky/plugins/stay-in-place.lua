return {
  'gbprod/stay-in-place.nvim',
  init = function()
    vim.keymap.set('n', '>', function()
      return require('stay-in-place').shift_right()
    end, { expr = true })
    vim.keymap.set('n', '<', function()
      return require('stay-in-place').shift_left
    end, { expr = true })
    vim.keymap.set('n', '=', function()
      return require('stay-in-place').filter()
    end, { expr = true })

    vim.keymap.set('n', '>>', function()
      require('stay-in-place').shift_right_line()
    end)
    vim.keymap.set('n', '<<', function()
      require('stay-in-place').shift_left_line()
    end)
    vim.keymap.set('n', '==', function()
      require('stay-in-place').filter_line()
    end)

    vim.keymap.set('x', '>', function()
      require('stay-in-place').shift_right_visual()
    end)
    vim.keymap.set('x', '<', function()
      require('stay-in-place').shift_left_visual()
    end)
    vim.keymap.set('x', '=', function()
      require('stay-in-place').filter_visual()
    end)
  end,
  config = function()
    require('stay-in-place').setup({
      set_keymaps = false,
    })
  end,
}
