return {
  {
    'uga-rosa/ccc.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = { highlighter = { auto_enable = true } },
  },
  { 'mtdl9/vim-log-highlighting', ft = 'log' },
  { 'johmsalas/text-case.nvim', config = true },
  { 'axelvc/template-string.nvim', enabled = false, config = true },
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
  { 'wsdjeg/vim-fetch', event = 'CmdlineEnter' },
  { 'justinmk/vim-gtfo', keys = { 'got', 'gof' } },
  {
    'samjwill/nvim-unception',
    lazy = false,
    init = function()
      -- vim.g.unception_open_buffer_in_new_tab = true
      vim.g.unception_delete_replaced_buffer = true
    end,
  },
  { 'stevearc/profile.nvim', cond = vim.env.NVIM_PROFILE },
}
