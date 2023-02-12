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
    require('which-key').register({
      ['<Leader>d'] = { name = '+diagnostic' },
      ['<Leader>f'] = { name = '+fuzzy finder' },
      ['<Leader>g'] = { name = '+git' },
      ['<Leader>h'] = { name = '+gitsigns' },
      ['['] = { name = '+previous' },
      [']'] = { name = '+next' },
      ['g'] = { name = '+goto' },
    })

    vim.keymap.set('n', 'g?', '<Cmd>WhichKey<CR>')
  end,
}
