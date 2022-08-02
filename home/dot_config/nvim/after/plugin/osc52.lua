vim.keymap.set('n', '<LocalLeader>y', require('osc52').copy_operator, { expr = true })
vim.keymap.set('x', '<LocalLeader>y', require('osc52').copy_visual)
