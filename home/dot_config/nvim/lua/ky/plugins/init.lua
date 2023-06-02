return {
  {
    'uga-rosa/ccc.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = { highlighter = { auto_enable = false } },
  },
  {
    'akinsho/git-conflict.nvim',
    enabled = false,
    event = { 'BufReadPost', 'BufNewFile' },
    config = true,
  },
  { 'AndrewRadev/linediff.vim', cmd = 'Linediff' },
  { 'AckslD/nvim-FeMaco.lua', cmd = 'FeMaco', config = true },
  { 'nvim-lua/plenary.nvim' },
  { 'justinmk/vim-gtfo', keys = { 'got', 'gof' } },
}
