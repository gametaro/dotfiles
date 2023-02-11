return {
  't9md/vim-quickhl',
  keys = {
    {
      '<Leader>m',
      '<Plug>(quickhl-manual-this-whole-word)',
      mode = { 'n', 'x' },
      desc = 'Highlight word',
    },
    { '<Leader>M', '<Plug>(quickhl-manual-reset)', mode = { 'n', 'x' }, desc = 'Unhighlight word' },
  },
}
