return {
  'chomosuke/term-edit.nvim',
  event = 'TermOpen',
  cond = false,
  config = function()
    require('term-edit').setup({
      prompt_end = '$ ',
      -- prompt_end = '❯ ',
    })
  end,
}
