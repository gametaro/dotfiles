return {
  { 'norcalli/nvim-colorizer.lua' },
  { 'mtdl9/vim-log-highlighting' },
  { 'itchyny/vim-highlighturl', event = 'BufReadPost' },
  { 'johmsalas/text-case.nvim', config = true },
  { 'axelvc/template-string.nvim', enabled = false, config = true },
  { 'smjonas/inc-rename.nvim', cmd = 'IncRename', config = true },
  { 'akinsho/git-conflict.nvim', event = 'BufReadPost', config = true },
  { 'AndrewRadev/linediff.vim', cmd = 'Linediff' },
  { 'bkad/CamelCaseMotion', lazy = false },
  { 'AckslD/nvim-FeMaco.lua', cmd = 'FeMaco', config = true },
  { 'nvim-lua/plenary.nvim' },
  { 'nacro90/numb.nvim', event = 'CmdlineEnter', config = true },
  { 'wsdjeg/vim-fetch', event = 'CmdlineEnter' },
  { 'justinmk/vim-gtfo', keys = { 'got', 'gof' } },
  { 'samjwill/nvim-unception', enabled = false, lazy = false },
}
