local ok = prequire('todo-comments')
if not ok then
  return
end

vim.keymap.set('n', '<LocalLeader>tq', vim.cmd.TodoQuickFix)
vim.keymap.set('n', '<LocalLeader>tl', vim.cmd.TodoLocList)
vim.keymap.set('n', ']t', require('todo-comments').jump_next)
vim.keymap.set('n', '[t', require('todo-comments').jump_prev)

require('todo-comments').setup()
