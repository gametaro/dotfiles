return {
  'folke/todo-comments.nvim',
  cmd = { 'TodoQuickFix', 'TodoLocList' },
  init = function()
    vim.keymap.set('n', '<Leader>tq', vim.cmd.TodoQuickFix)
    vim.keymap.set('n', '<Leader>tl', vim.cmd.TodoLocList)
    vim.keymap.set('n', ']t', function()
      require('todo-comments').jump_next()
    end, { desc = 'Next todo comment' })

    vim.keymap.set('n', '[t', function()
      require('todo-comments').jump_prev()
    end, { desc = 'Previous todo comment' })
  end,
  config = true,
}
