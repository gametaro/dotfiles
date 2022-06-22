local ok = prequire('todo-comments')
if not ok then
  return
end

vim.keymap.set('n', '<LocalLeader>tq', '<Cmd>TodoQuickFix<CR>')
vim.keymap.set('n', '<LocalLeader>tl', '<Cmd>TodoLocList<CR>')
vim.keymap.set('n', '<LocalLeader>tt', '<Cmd>TodoTrouble<CR>')

require('todo-comments').setup()
