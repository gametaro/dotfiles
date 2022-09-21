local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
if not vim.loop.fs_stat(install_path) then
  vim.fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  })
end

vim.cmd.packadd('packer.nvim')
local packer = require('packer')

packer.startup({
  function(use)
    -- Package manager
    use({ 'wbthomason/packer.nvim', opt = true })

    -- Icon
    use('kyazdani42/nvim-web-devicons')

    -- Syntax/Highlight
    use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' })
    use('p00f/nvim-ts-rainbow')
    use('m-demare/hlargs.nvim')
    use('zbirenbaum/neodim')
    use({ 'norcalli/nvim-colorizer.lua', opt = true })
    use('mtdl9/vim-log-highlighting')
    use('nvim-treesitter/playground')
    use('levouh/tint.nvim')
    use('RRethy/vim-illuminate')
    use({ 't9md/vim-quickhl', keys = '<Plug>(quickhl-' })

    -- Editing support
    use('gbprod/substitute.nvim')
    use('gbprod/yanky.nvim')
    use('gbprod/stay-in-place.nvim')
    use({ 'kana/vim-niceblock', keys = '<Plug>(niceblock-' })
    use('gpanders/editorconfig.nvim')
    use('andymass/vim-matchup')
    use({ 'machakann/vim-swap', keys = '<Plug>(swap-' })
    -- use('machakann/vim-sandwich')
    use('monaqa/dial.nvim')
    use('windwp/nvim-autopairs')
    use('ojroques/nvim-osc52')
    use('echasnovski/mini.nvim')
    use('tpope/vim-repeat')
    use('windwp/nvim-ts-autotag')
    use('johmsalas/text-case.nvim')
    -- use('AckslD/nvim-trevJ.lua')
    use('aarondiel/spread.nvim')
    use('kylechui/nvim-surround')
    use('smjonas/live-command.nvim')
    use('axelvc/template-string.nvim')

    -- LSP
    use('neovim/nvim-lspconfig')
    use('williamboman/mason.nvim')
    use('williamboman/mason-lspconfig.nvim')
    use('b0o/schemastore.nvim')
    use('ii14/emmylua-nvim')
    use('jose-elias-alvarez/null-ls.nvim')
    use('jose-elias-alvarez/typescript.nvim')
    use('lukas-reineke/lsp-format.nvim')
    use('smjonas/inc-rename.nvim')
    use('kosayoda/nvim-lightbulb')
    -- use('https://git.sr.ht/~whynothugo/lsp_lines.nvim')

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
    use('danymat/neogen')

    -- Statusline
    use('rebelot/heirline.nvim')

    -- Colorscheme
    use({ 'EdenEast/nightfox.nvim', opt = true })
    use({ 'rebelot/kanagawa.nvim', opt = true })
    use({ 'Mofiqul/vscode.nvim', opt = true })
    use({ 'cocopon/iceberg.vim', opt = true })
    use({ 'catppuccin/nvim', opt = true })
    use({ 'folke/tokyonight.nvim', opt = true })

    -- Keybinding
    use('folke/which-key.nvim')
    use('anuvyklack/hydra.nvim')

    -- File explorer
    use('tamago324/lir.nvim')
    use('tamago324/lir-git-status.nvim')

    -- Search
    use('haya14busa/vim-asterisk')
    use('kevinhwang91/nvim-hlslens')

    -- Git/Diff
    use('TimUntersberger/neogit')
    use('sindrets/diffview.nvim')
    use('lewis6991/gitsigns.nvim')
    use('rhysd/committia.vim')
    use({ 'rhysd/git-messenger.vim', keys = '<Plug>(git-messenger' })
    use('ruifm/gitlinker.nvim')
    -- use('akinsho/git-conflict.nvim')
    use('hotwatermorning/auto-git-diff')
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
    use({ 'haya14busa/vim-edgemotion', keys = '<Plug>(edgemotion-' })
    use('bkad/CamelCaseMotion')
    use({ 'kana/vim-smartword', event = 'VimEnter' })
    use({ 'gametaro/pounce.nvim', branch = 'cword' })
    -- use { 'hrsh7th/vim-eft', on = '<Plug>(eft-' }
    use({ 'rainbowhxch/accelerated-jk.nvim', keys = '<Plug>(accelerated_jk_' })

    -- Text object
    use('nvim-treesitter/nvim-treesitter-textobjects')
    use('mfussenegger/nvim-treehopper')
    use('David-Kunz/treesitter-unit')
    -- use('kana/vim-textobj-user')
    -- use('kana/vim-textobj-entire')
    -- use('kana/vim-textobj-line')
    -- use('kana/vim-textobj-indent')
    -- use('Julian/vim-textobj-variable-segment')
    -- use('andrewferrier/textobj-diagnostic.nvim')

    -- Fuzzy Finder
    use('nvim-telescope/telescope.nvim')
    use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })
    use('natecraddock/telescope-zf-native.nvim')
    use('nvim-telescope/telescope-live-grep-args.nvim')
    use({ 'ilAYAli/scMRU.nvim' })
    use({ 'junegunn/fzf', run = 'call fzf#install()' })

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
    use({ 'iamcco/markdown-preview.nvim', run = 'call mkdp#util#install()' })
    use('AckslD/nvim-FeMaco.lua')

    -- Session
    -- use('rmagatti/auto-session')

    -- Marks
    use('ThePrimeagen/harpoon')
    -- use('chentoast/marks.nvim')

    -- Quickfix
    use('kevinhwang91/nvim-bqf')

    -- UI
    use('rcarriga/nvim-notify')
    -- use('stevearc/dressing.nvim')

    -- Utility
    use('nvim-lua/plenary.nvim')
    use({ 'lewis6991/impatient.nvim', opt = true })
    -- use({ 'tyru/capture.vim', cmd = 'Capture' })
    use({ 'tyru/open-browser.vim', keys = '<Plug>(openbrowser-smart-search)' })
    use('AckslD/messages.nvim')
    use('lambdalisue/suda.vim')
    vim.g.suda_smart_edit = 1
    use({ 'psliwka/vim-dirtytalk', run = ':DirtytalkUpdate' })
    use('nacro90/numb.nvim')
    use('wsdjeg/vim-fetch')
    use('justinmk/vim-gtfo')
    use({ 'dstein64/vim-startuptime', cmd = 'StartupTime' })
    use('nvim-treesitter/nvim-treesitter-context')
  end,
  config = {
    display = {
      prompt_border = require('ky.ui').border,
    },
  },
})

vim.keymap.set('n', '<LocalLeader>pc', packer.compile)
vim.keymap.set('n', '<LocalLeader>pC', packer.clean)
vim.keymap.set('n', '<LocalLeader>ps', packer.sync)
vim.keymap.set('n', '<LocalLeader>pS', packer.status)
vim.keymap.set('n', '<LocalLeader>pu', packer.update)
vim.keymap.set('n', '<LocalLeader>pi', packer.install)

vim.api.nvim_create_autocmd('User', {
  group = vim.api.nvim_create_augroup('PackerCompileDone', { clear = true }),
  pattern = 'PackerCompileDone',
  callback = function()
    vim.notify('packer.compile: Complete', vim.log.levels.INFO, { title = 'packer.nvim' })
  end,
})
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = 'plugins.lua',
  group = vim.api.nvim_create_augroup('PackerCompileOnWrite', { clear = true }),
  callback = function()
    vim.schedule(packer.compile)
  end,
})
