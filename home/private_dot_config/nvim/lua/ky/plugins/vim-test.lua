return {
  'vim-test/vim-test',
  keys = {
    { '<Leader>tn', vim.cmd.TestNearest },
    { '<Leader>tf', vim.cmd.TestFile },
    { '<Leader>ts', vim.cmd.TestSuite },
    { '<Leader>tv', vim.cmd.TestVisit },
  },
  init = function()
    vim.g['test#strategy'] = 'harpoon'
    vim.g['test#harpoon_term'] = 1
  end,
}
