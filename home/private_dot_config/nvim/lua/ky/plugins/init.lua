return {
  { 'norcalli/nvim-colorizer.lua' },
  { 'mtdl9/vim-log-highlighting' },
  { 'itchyny/vim-highlighturl', event = 'BufReadPost' },
  { 'gpanders/editorconfig.nvim' },
  { 'johmsalas/text-case.nvim', config = true },
  { 'axelvc/template-string.nvim', enabled = false, config = true },
  { 'smjonas/inc-rename.nvim', cmd = 'IncRename', config = true },
  { 'akinsho/git-conflict.nvim', event = 'BufReadPost', config = true },
  { 'AndrewRadev/linediff.vim', cmd = { 'Linediff' } },
  {
    dir = '~/projects/edgemotion.nvim',
    keys = {
      {
        mode = { 'n', 'x' },
        '<C-j>',
        function()
          return require('edgemotion').move(1)
        end,
        expr = true,
      },
      {
        mode = { 'n', 'x' },
        '<C-k>',
        function()
          return require('edgemotion').move(0)
        end,
        expr = true,
      },
    },
  },
  { 'bkad/CamelCaseMotion', lazy = false },
  { 'AckslD/nvim-FeMaco.lua', cmd = 'FeMaco', config = true },
  { 'nvim-lua/plenary.nvim' },
  { 'nacro90/numb.nvim', event = 'CmdlineEnter', config = true },
  { 'wsdjeg/vim-fetch', event = 'CmdlineEnter' },
  { 'justinmk/vim-gtfo', keys = { 'got', 'gof' } },
  { 'samjwill/nvim-unception', lazy = false },
}
