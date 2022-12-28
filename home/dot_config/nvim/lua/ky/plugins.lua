return {
  -- Icon
  {
    'kyazdani42/nvim-web-devicons',
    dependencies = 'DaikyXendo/nvim-material-icon',
    config = function()
      require('nvim-web-devicons').setup({
        override = require('nvim-material-icon').get_icons(),
      })
    end,
  },

  -- Syntax/Highlight
  { 'norcalli/nvim-colorizer.lua' },
  { 'mtdl9/vim-log-highlighting' },
  { 'itchyny/vim-highlighturl', event = 'BufReadPost' },
  {
    't9md/vim-quickhl',
    keys = { '<LocalLeader>m', '<LocalLeader>M' },
    config = function()
      vim.keymap.set({ 'n', 'x' }, '<LocalLeader>m', '<Plug>(quickhl-manual-this-whole-word)')
      vim.keymap.set({ 'n', 'x' }, '<LocalLeader>M', '<Plug>(quickhl-manual-reset)')
    end,
  },

  -- Editing support
  {
    'kana/vim-niceblock',
    keys = { { 'A', mode = 'x' }, { 'I', mode = 'x' }, { 'gI', mode = 'x' } },
  },
  { 'gpanders/editorconfig.nvim' },
  { 'johmsalas/text-case.nvim', config = true },
  { 'axelvc/template-string.nvim', enabled = false, config = true },

  { 'smjonas/inc-rename.nvim', cmd = 'IncRename', config = true },

  -- ColorScheme
  { 'EdenEast/nightfox.nvim' },
  { 'rebelot/kanagawa.nvim' },
  { 'Mofiqul/vscode.nvim' },
  { 'cocopon/iceberg.vim' },
  { 'catppuccin/nvim' },
  { 'folke/tokyonight.nvim' },

  -- Git/Diff
  -- {
  --   'rhysd/committia.vim',
  --   config = function()
  --     vim.g.committia_hooks = {
  --       edit_open = function(info)
  --         if info.vcs == 'git' and vim.api.nvim_get_current_line() == '' then
  --           vim.cmd.startinsert()
  --         end
  --         vim.keymap.set(
  --           'i',
  --           '<C-f>',
  --           '<Plug>(committia-scroll-diff-down-half)',
  --           { buffer = info.edit_bufnr }
  --         )
  --         vim.keymap.set(
  --           'i',
  --           '<C-b>',
  --           '<Plug>(committia-scroll-diff-up-half)',
  --           { buffer = info.edit_bufnr }
  --         )
  --       end,
  --     }
  --   end,
  -- },
  { 'akinsho/git-conflict.nvim', event = 'BufReadPost', config = true },
  { 'AndrewRadev/linediff.vim', cmd = { 'Linediff' } },

  -- Motion
  {
    'haya14busa/vim-edgemotion',
    keys = { { '<C-j>', mode = { 'n', 'x' } }, { '<C-k>', mode = { 'n', 'x' } } },
    config = function()
      vim.keymap.set({ 'n', 'x' }, '<C-j>', "m'<Plug>(edgemotion-j)")
      vim.keymap.set({ 'n', 'x' }, '<C-k>', "m'<Plug>(edgemotion-k)")
    end,
  },
  { 'bkad/CamelCaseMotion', lazy = false },

  -- Comment
  -- {
  --   'numToStr/Comment.nvim',
  --   require('Comment').setup({
  --     ignore = '^$',
  --     pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
  --   }),
  -- },

  -- Test
  {
    'vim-test/vim-test',
    init = function()
      vim.g['test#strategy'] = 'harpoon'
      vim.g['test#harpoon_term'] = 1

      vim.keymap.set('n', '<LocalLeader>tn', vim.cmd.TestNearest)
      vim.keymap.set('n', '<LocalLeader>tf', vim.cmd.TestFile)
      vim.keymap.set('n', '<LocalLeader>ts', vim.cmd.TestSuite)
      vim.keymap.set('n', '<LocalLeader>tv', vim.cmd.TestVisit)
    end,
  },

  -- Markdown
  {
    'iamcco/markdown-preview.nvim',
    build = function()
      vim.fn['mkdp#util#install']()
    end,
    ft = 'markdown',
  },
  { 'AckslD/nvim-FeMaco.lua', cmd = 'FeMaco', config = true },

  -- Session
  -- {
  --   'rmagatti/auto-session',
  --   config = function()
  --     require('auto-session').setup({
  --       log_level = 'error',
  --     })
  --   end,
  -- },
  {
    'Shatur/neovim-session-manager',
    lazy = false,
    config = function()
      require('session_manager').setup({
        autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir,
        autosave_ignore_filetypes = { 'gitcommit', 'gitrebase' },
      })
    end,
  },

  -- Utility
  { 'nvim-lua/plenary.nvim' },
  {
    'tyru/open-browser.vim',
    keys = { 'gx', mode = { 'n', 'x' } },
    config = function()
      vim.keymap.set({ 'n', 'x' }, 'gx', '<Plug>(openbrowser-smart-search)')
      require('ky.abbrev').cabbrev('ob', 'OpenBrowserSmartSearch')
    end,
  },
  {
    'lambdalisue/suda.vim',
    lazy = false,
    init = function()
      vim.g.suda_smart_edit = 1
    end,
  },
  { 'psliwka/vim-dirtytalk', build = ':DirtytalkUpdate' },
  { 'nacro90/numb.nvim', event = 'CmdlineEnter', config = true },
  { 'wsdjeg/vim-fetch', event = 'CmdlineEnter' },
  { 'justinmk/vim-gtfo', keys = { 'got', 'gof' } },
  {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime',
    init = function()
      vim.g.startuptime_exe_args = { '--cmd', 'let g:unception_disable=1' }
    end,
  },
  { 'samjwill/nvim-unception', lazy = false },
  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    init = function()
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_SplitWidth = 40
      vim.g.undotree_WindowLayout = 2
      vim.keymap.set('n', '<LocalLeader>u', vim.cmd.UndotreeToggle)
    end,
  },
}
