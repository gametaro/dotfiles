return {
  {
    'uga-rosa/ccc.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = { highlighter = { auto_enable = true } },
  },
  {
    'akinsho/git-conflict.nvim',
    enabled = false,
    event = { 'BufReadPost', 'BufNewFile' },
    config = true,
  },
  { 'AndrewRadev/linediff.vim', cmd = 'Linediff' },
  { 'bkad/CamelCaseMotion', lazy = false },
  { 'AckslD/nvim-FeMaco.lua', cmd = 'FeMaco', config = true },
  { 'nvim-lua/plenary.nvim' },
  { 'nacro90/numb.nvim', event = 'CmdlineEnter', config = true },
  { 'justinmk/vim-gtfo', keys = { 'got', 'gof' } },
}
