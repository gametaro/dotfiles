return {
  'danymat/neogen',
  cmd = 'Neogen',
  init = function()
    vim.keymap.set('n', '<Leader>nf', function()
      require('neogen').generate()
    end)
    vim.keymap.set('n', '<Leader>nt', function()
      require('neogen').generate({ type = 'type' })
    end)
    vim.keymap.set('n', '<Leader>nc', function()
      require('neogen').generate({ type = 'class' })
    end)
    vim.keymap.set('n', '<Leader>nF', function()
      require('neogen').generate({ type = 'file' })
    end)
  end,
  config = function()
    require('neogen').setup({ snippet_engine = 'luasnip' })
  end,
}
