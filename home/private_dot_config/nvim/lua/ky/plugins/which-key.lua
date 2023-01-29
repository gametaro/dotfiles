return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  config = function()
    require('which-key').setup({
      plugins = {
        spelling = {
          enabled = true,
        },
      },
    })
    -- HACK: remove `*` and `+`
    require('which-key.plugins').plugins.registers.registers =
      '"-:.%/#=_abcdefghijklmnopqrstuvwxyz0123456789'
    -- '*+"-:.%/#=_abcdefghijklmnopqrstuvwxyz0123456789'
  end,
}
