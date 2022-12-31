return {
  't9md/vim-quickhl',
  keys = {
    { '<LocalLeader>m', '<Plug>(quickhl-manual-this-whole-word)', mode = { 'n', 'x' } },
    { '<LocalLeader>M', '<Plug>(quickhl-manual-reset)', mode = { 'n', 'x' } },
  },
}
