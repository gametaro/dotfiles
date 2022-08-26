vim.g['test#strategy'] = 'harpoon'
vim.g['test#harpoon_term'] = 1

vim.keymap.set('n', '<LocalLeader>tn', vim.cmd.TestNearest)
vim.keymap.set('n', '<LocalLeader>tf', vim.cmd.TestFile)
vim.keymap.set('n', '<LocalLeader>ts', vim.cmd.TestSuite)
vim.keymap.set('n', '<LocalLeader>tv', vim.cmd.TestVisit)
