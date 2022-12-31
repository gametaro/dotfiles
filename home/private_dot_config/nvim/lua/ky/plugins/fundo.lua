return {
  'kevinhwang91/nvim-fundo',
  dependencies = 'kevinhwang91/promise-async',
  enabled = false,
  build = function()
    require('fundo').install()
  end,
  lazy = false,
  config = true,
}
