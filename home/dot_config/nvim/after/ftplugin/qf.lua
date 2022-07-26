vim.bo.buflisted = false
vim.wo.list = false
vim.wo.number = true
vim.wo.relativenumber = false

vim.keymap.set('n', 'cc', function()
  vim.cmd.cexpr('[]')
end, { buffer = true, desc = 'clear quickfix list' })
