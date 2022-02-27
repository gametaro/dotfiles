vim.opt_local.buflisted = false
vim.opt_local.list = false
vim.opt_local.number = true
vim.opt_local.relativenumber = false

vim.keymap.set('n', 'cc', function()
  vim.cmd('cexpr []')
end, { buffer = true, desc = 'clear quickfix list' })
