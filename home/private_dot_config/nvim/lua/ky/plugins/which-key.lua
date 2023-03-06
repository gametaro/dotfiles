return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  config = function()
    require('which-key').setup()
    -- HACK: remove `*` and `+`
    require('which-key.plugins').plugins.registers.registers =
      '"-:.%/#=_abcdefghijklmnopqrstuvwxyz0123456789'
    -- '*+"-:.%/#=_abcdefghijklmnopqrstuvwxyz0123456789'
    require('which-key').register({
      ['<Leader>c'] = { name = '+lsp code' },
      ['<Leader>d'] = { name = '+diagnostic' },
      ['<Leader>f'] = { name = '+fuzzy finder' },
      ['<Leader>g'] = { name = '+git' },
      ['<Leader>h'] = { name = '+gitsigns' },
      ['<Leader>l'] = { name = '+lsp symbols' },
      ['<Leader>n'] = { name = '+neogen' },
      ['<Leader>o'] = { name = '+olddirs' },
      ['<Leader>t'] = { name = '+test/todo' },
      ['['] = { name = '+previous' },
      ['\\'] = { name = '+toggle' },
      ['\\h'] = { name = '+gitsigns' },
      [']'] = { name = '+next' },
      ['g'] = { name = '+goto' },
    })

    vim.keymap.set('n', 'g?', '<Cmd>WhichKey<CR>')
  end,
}
