return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  config = function()
    require('which-key').setup({
      plugins = {
        marks = false,
        spelling = {
          enabled = true,
        },
      },
      show_help = false,
      show_keys = false,
    })
  end,
}
