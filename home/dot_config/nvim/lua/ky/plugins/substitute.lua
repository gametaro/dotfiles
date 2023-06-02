return {
  'gbprod/substitute.nvim',
  init = function()
    vim.keymap.set('n', '_', function()
      require('substitute').operator()
    end, { desc = 'Substitute' })
    vim.keymap.set('x', '_', function()
      require('substitute').visual()
    end, { desc = 'Substitute' })
    vim.keymap.set('n', 'X', function()
      require('substitute.exchange').operator()
    end, { desc = 'Exchange' })
    vim.keymap.set('x', 'X', function()
      require('substitute.exchange').visual()
    end, { desc = 'Exchange' })
    vim.keymap.set('n', 'Xc', function()
      require('substitute.exchange').cancel()
    end, { desc = 'Exchange' })
  end,
  config = true,
}
