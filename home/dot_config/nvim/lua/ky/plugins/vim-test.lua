return {
  'vim-test/vim-test',
  keys = {
    { '<LocalLeader>tn', vim.cmd.TestNearest },
    { '<LocalLeader>tf', vim.cmd.TestFile },
    { '<LocalLeader>ts', vim.cmd.TestSuite },
    { '<LocalLeader>tv', vim.cmd.TestVisit },
  },
  init = function()
    vim.g['test#strategy'] = 'harpoon'
    vim.g['test#harpoon_term'] = 1
  end,
}
