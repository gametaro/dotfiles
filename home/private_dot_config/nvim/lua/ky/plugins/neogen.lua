return {
  'danymat/neogen',
  cmd = 'Neogen',
  init = function()
    vim.keymap.set('n', '<Leader>nf', '<Cmd>Neogen<CR>')
    vim.keymap.set('n', '<Leader>nt', '<Cmd>Neogen type<CR>')
    vim.keymap.set('n', '<Leader>nc', '<Cmd>Neogen class<CR>')
    vim.keymap.set('n', '<Leader>nF', '<Cmd>Neogen file<CR>')
  end,
  config = function()
    require('neogen').setup({ snippet_engine = 'luasnip' })
  end,
}
