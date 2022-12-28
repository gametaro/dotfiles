return {
  'folke/todo-comments.nvim',
  init = function()
    vim.keymap.set('n', '<LocalLeader>tq', vim.cmd.TodoQuickFix)
    vim.keymap.set('n', '<LocalLeader>tl', vim.cmd.TodoLocList)
    vim.keymap.set('n', ']t', function()
      require('todo-comments').jump_next()
    end, { desc = 'Next todo comment' })

    vim.keymap.set('n', '[t', function()
      require('todo-comments').jump_prev()
    end, { desc = 'Previous todo comment' })
  end,
  config = true,
}
