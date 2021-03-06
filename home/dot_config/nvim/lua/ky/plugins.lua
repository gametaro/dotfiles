local api = vim.api

local bootstrapping = false

local stdpath = vim.fn.stdpath('data')
local jetpack_path = '%s/site/pack/jetpack/%s/vim-jetpack'
local src_path = string.format(jetpack_path, stdpath, 'src')
local opt_path = string.format(jetpack_path, stdpath, 'opt')
if not vim.loop.fs_stat(src_path) then
  vim.notify('Installing vim-jetpack...')
  vim.fn.system {
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/tani/vim-jetpack',
    src_path,
  }

  vim.fn.mkdir(stdpath .. '/site/pack/jetpack/opt', 'p')
  vim.loop.fs_symlink(src_path, opt_path, { dir = true })

  bootstrapping = true
end

vim.cmd.packadd('vim-jetpack')
local jetpack = require('jetpack')
vim.g.jetpack_copy_method = 'symlink'

jetpack.startup(function(use)
  -- Package manager
  use { 'tani/vim-jetpack', opt = true }

  -- Icon
  use('kyazdani42/nvim-web-devicons')

  -- Syntax
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use('p00f/nvim-ts-rainbow')
  use('m-demare/hlargs.nvim')
  use('zbirenbaum/neodim')
  use { 'norcalli/nvim-colorizer.lua', opt = true }
  use('mtdl9/vim-log-highlighting')
  use {
    'nvim-treesitter/playground',
    on = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' },
  }

  -- Editing support
  use('gbprod/substitute.nvim')
  use('gbprod/yanky.nvim')
  use('gbprod/stay-in-place.nvim')
  use { 'kana/vim-niceblock', on = '<Plug>(niceblock-' }
  use('gpanders/editorconfig.nvim')
  use('andymass/vim-matchup')
  use { 'machakann/vim-swap', on = '<Plug>(swap-' }
  -- use('machakann/vim-sandwich')
  use('monaqa/dial.nvim')
  use('windwp/nvim-autopairs')
  use('ojroques/vim-oscyank')
  use('echasnovski/mini.nvim')
  use('tpope/vim-repeat')
  use('windwp/nvim-ts-autotag')
  use('johmsalas/text-case.nvim')
  use('AckslD/nvim-trevJ.lua')
  use('kylechui/nvim-surround')
  use('smjonas/live-command.nvim')

  -- LSP
  use('neovim/nvim-lspconfig')
  use { 'williamboman/mason.nvim' }
  use { 'williamboman/mason-lspconfig.nvim' }
  use('b0o/schemastore.nvim')
  use('ii14/emmylua-nvim')
  use('jose-elias-alvarez/null-ls.nvim')
  use('jose-elias-alvarez/typescript.nvim')
  use('lukas-reineke/lsp-format.nvim')
  use('smjonas/inc-rename.nvim')
  use('kosayoda/nvim-lightbulb')
  use('https://git.sr.ht/~whynothugo/lsp_lines.nvim')

  -- Completion/Snippets
  use('hrsh7th/nvim-cmp')
  use('hrsh7th/cmp-nvim-lsp')
  use('hrsh7th/cmp-buffer')
  use('hrsh7th/cmp-path')
  use('hrsh7th/cmp-cmdline')
  use('hrsh7th/cmp-nvim-lsp-document-symbol')
  use('hrsh7th/cmp-emoji')
  use('saadparwaiz1/cmp_luasnip')
  use('f3fora/cmp-spell')
  use('petertriho/cmp-git')
  use('L3MON4D3/LuaSnip')
  use('rafamadriz/friendly-snippets')

  -- Statusline
  use('rebelot/heirline.nvim')

  -- Colorscheme
  use { 'EdenEast/nightfox.nvim', opt = true }
  use { 'rebelot/kanagawa.nvim', opt = true }
  use { 'Mofiqul/vscode.nvim', opt = true }
  use { 'cocopon/iceberg.vim', opt = true }
  use { 'catppuccin/nvim', opt = true }
  use { 'folke/tokyonight.nvim', opt = true }

  -- Keybinding
  use('folke/which-key.nvim')
  use('anuvyklack/hydra.nvim')

  -- File explorer
  use('tamago324/lir.nvim')
  use('tamago324/lir-git-status.nvim')

  -- Search
  use('haya14busa/vim-asterisk')
  use('kevinhwang91/nvim-hlslens')
  use { 't9md/vim-quickhl', on = '<Plug>(quickhl-' }

  -- Git/Diff
  use { 'TimUntersberger/neogit', on = ':Neogit' }
  use { 'sindrets/diffview.nvim', on = { ':DiffviewOpen', ':DiffviewFileHistory' } }
  use('lewis6991/gitsigns.nvim')
  use { 'rhysd/committia.vim', ft = { 'gitcommit' } }
  use { 'rhysd/git-messenger.vim', on = '<Plug>(git-messenger' }
  use('ruifm/gitlinker.nvim')
  use('akinsho/git-conflict.nvim')
  use { 'hotwatermorning/auto-git-diff', ft = { 'gitrebase' } }
  use('AndrewRadev/linediff.vim')
  -- use {
  --   'github/copilot.vim',
  --   setup = function()
  --     vim.g.copilot_no_tab_map = true
  --     vim.api.nvim_set_keymap('i', '<C-m>', [[copilot#Accept("\<CR>")]], {
  --       noremap = true,
  --       script = true,
  --       expr = true,
  --     })
  --   end,
  -- }

  -- Motion
  use { 'haya14busa/vim-edgemotion', on = '<Plug>(edgemotion-' }
  use('bkad/CamelCaseMotion')
  use { 'kana/vim-smartword', on = 'VimEnter' }
  use { 'rlane/pounce.nvim', on = { ':Pounce', ':PounceRepeat' } }
  -- use { 'hrsh7th/vim-eft', on = '<Plug>(eft-' }
  use { 'rainbowhxch/accelerated-jk.nvim', on = '<Plug>(accelerated_jk_' }

  -- Text object
  use('nvim-treesitter/nvim-treesitter-textobjects')
  use('mfussenegger/nvim-treehopper')
  use('David-Kunz/treesitter-unit')
  -- use('kana/vim-textobj-user')
  -- use('kana/vim-textobj-entire')
  -- use('kana/vim-textobj-line')
  -- use('kana/vim-textobj-indent')
  -- use('Julian/vim-textobj-variable-segment')
  use('andrewferrier/textobj-diagnostic.nvim')

  -- Fuzzy Finder
  use('nvim-telescope/telescope.nvim')
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use('natecraddock/telescope-zf-native.nvim')
  use('nvim-telescope/telescope-live-grep-args.nvim')
  use { 'ilAYAli/scMRU.nvim' }
  use { 'junegunn/fzf', run = 'call fzf#install()' }

  -- Comment
  -- use('numToStr/Comment.nvim')
  use('folke/todo-comments.nvim')
  use('JoosepAlviste/nvim-ts-context-commentstring')

  -- Project
  use('ahmedkhalf/project.nvim')
  use('tpope/vim-projectionist')

  -- Test
  use('vim-test/vim-test')

  -- Markdown
  use { 'iamcco/markdown-preview.nvim', run = 'call mkdp#util#install()' }

  -- Session
  -- use('rmagatti/auto-session')

  -- Marks
  use('ThePrimeagen/harpoon')
  use('chentoast/marks.nvim')

  -- Quickfix
  use { 'kevinhwang91/nvim-bqf', ft = 'qf' }

  -- UI
  use('rcarriga/nvim-notify')
  -- use('stevearc/dressing.nvim')

  -- Utility
  use('nvim-lua/plenary.nvim')
  use { 'lewis6991/impatient.nvim', opt = true }
  use { 'tyru/capture.vim', on = ':Capture' }
  use {
    'tyru/open-browser.vim',
    on = {
      '<Plug>(openbrowser-smart-search)',
      ':OpenBrowserSmartSearch',
    },
  }
  use('antoinemadec/FixCursorHold.nvim')
  use('lambdalisue/suda.vim')
  vim.g.suda_smart_edit = 1
  use { 'psliwka/vim-dirtytalk', run = ':DirtytalkUpdate' }
  use('nacro90/numb.nvim')
  use('wsdjeg/vim-fetch')
  use('justinmk/vim-gtfo')
  use { 'dstein64/vim-startuptime', on = ':StartupTime' }
end)

local sync = function()
  local names = jetpack.names()
  if not vim.tbl_isempty(names) then
    for _, name in ipairs(names) do
      if not jetpack.tap(name) then
        jetpack.sync()
        if bootstrapping then vim.cmd.quitall { bang = true } end
        break
      end
    end
  end
end

local group = api.nvim_create_augroup('jetpack', { clear = true })
api.nvim_create_autocmd('VimEnter', {
  group = group,
  callback = sync,
})
api.nvim_create_autocmd('BufWritePost', {
  group = group,
  pattern = 'plugins.lua',
  callback = sync,
})

require('ky.abbrev').cabbrev('js', 'JetpackSync')
