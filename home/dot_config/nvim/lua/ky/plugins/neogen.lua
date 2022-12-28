return {
  'danymat/neogen',
  cmd = 'Neogen',
  init = function()
    vim.keymap.set('n', '<LocalLeader>nf', function()
      require('neogen').generate()
    end)
    vim.keymap.set('n', '<LocalLeader>nt', function()
      require('neogen').generate({ type = 'type' })
    end)
    vim.keymap.set('n', '<LocalLeader>nc', function()
      require('neogen').generate({ type = 'class' })
    end)
    vim.keymap.set('n', '<LocalLeader>nF', function()
      require('neogen').generate({ type = 'file' })
    end)
  end,
  config = function()
    require('neogen').setup({ snippet_engine = 'luasnip' })
  end,
}
