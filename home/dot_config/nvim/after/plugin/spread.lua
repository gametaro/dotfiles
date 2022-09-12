local ok = prequire('spread')
if not ok then
  return
end

local spread = require('spread')

vim.keymap.set('n', '<LocalLeader>j', spread.out)
vim.keymap.set('n', '<LocalLeader>J', spread.combine)
