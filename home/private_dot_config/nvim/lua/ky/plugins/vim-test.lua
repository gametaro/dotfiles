return {
  'vim-test/vim-test',
  keys = {
    { '<Leader>tn', '<Cmd>TestNearest<CR>' },
    { '<Leader>tf', '<Cmd>TestFile<CR>' },
    { '<Leader>ts', '<Cmd>TestSuite<CR>' },
    { '<Leader>tv', '<Cmd>TestVisit<CR>' },
  },
  init = function()
    vim.g['test#strategy'] = 'harpoon'
    vim.g['test#harpoon_term'] = 1
  end,
}
