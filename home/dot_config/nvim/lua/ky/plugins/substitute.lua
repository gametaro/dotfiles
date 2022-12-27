return {
  'gbprod/substitute.nvim',
  init = function()
    vim.keymap.set('n', '_', function()
      require('substitute').operator()
    end)
    vim.keymap.set('x', '_', function()
      require('substitute').visual()
    end)
    vim.keymap.set('n', 'X', function()
      require('substitute').visual()
    end)
    vim.keymap.set('x', 'X', function()
      require('substitute.exchange').visual()
    end)
    vim.keymap.set('n', 'Xc', function()
      require('substitute.exchange').cancel()
    end)
  end,
  config = function()
    require('substitute').setup({
      on_substitute = function(event)
        require('yanky').init_ring('p', event.register, event.count, event.vmode:match('[vV]'))
      end,
    })
  end,
}
