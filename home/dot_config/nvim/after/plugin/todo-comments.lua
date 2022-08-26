local ok = prequire('todo-comments')
if not ok then
  return
end

vim.keymap.set('n', '<LocalLeader>tq', vim.cmd.TodoQuickFix)
vim.keymap.set('n', '<LocalLeader>tl', vim.cmd.TodoLocList)

require('todo-comments').setup()
