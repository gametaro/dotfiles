vim.g['test#strategy'] = 'harpoon'
vim.g['test#harpoon_term'] = 1

vim.keymap.set('n', '<LocalLeader>tn', '<Cmd>TestNearest<CR>')
vim.keymap.set('n', '<LocalLeader>tf', '<Cmd>TestFile<CR>')
vim.keymap.set('n', '<LocalLeader>ts', '<Cmd>TestSuite<CR>')
vim.keymap.set('n', '<LocalLeader>tv', '<Cmd>TestVisit<CR>')
