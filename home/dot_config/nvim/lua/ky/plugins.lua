---check nvim is running on headless mode
local headless = #vim.api.nvim_list_uis() == 0

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

vim.cmd('packadd vim-jetpack')
local jetpack = require('jetpack')
jetpack.init { copy_method = 'symlink' }

jetpack.startup(function(use)
  use { 'tani/vim-jetpack', opt = true }
  use { 'lewis6991/impatient.nvim', opt = true }
  use('nvim-lua/plenary.nvim')
  use('kyazdani42/nvim-web-devicons')
  use('machakann/vim-sandwich')
  use('machakann/vim-swap')
  use { 'junegunn/fzf', run = 'call fzf#install()' }
  use('kevinhwang91/nvim-bqf')
  use('numToStr/Comment.nvim')
  use('monaqa/dial.nvim')

  use { 'tyru/capture.vim', on = ':Capture' }
  use { 'tyru/open-browser.vim', on = '<Plug>(openbrowser-smart-search)' }
  use { 'ruifm/gitlinker.nvim' }

  use { 'hrsh7th/vim-eft', on = '<Plug>(eft-' }

  use('nvim-treesitter/nvim-treesitter-textobjects')
  use('JoosepAlviste/nvim-ts-context-commentstring')
  use('p00f/nvim-ts-rainbow')
  use('windwp/nvim-ts-autotag')
  use { 'nvim-treesitter/playground', opt = true }
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use('gbprod/substitute.nvim')
  use { 'kana/vim-niceblock', on = '<Plug>(niceblock-' }

  use('neovim/nvim-lspconfig')
  use('williamboman/nvim-lsp-installer')
  use('b0o/schemastore.nvim')
  use('folke/lua-dev.nvim')
  use('jose-elias-alvarez/nvim-lsp-ts-utils')
  use('lukas-reineke/lsp-format.nvim')
  use('smjonas/inc-rename.nvim')
  use('jose-elias-alvarez/null-ls.nvim')

  use('hrsh7th/nvim-cmp')
  use('hrsh7th/cmp-nvim-lsp')
  use('hrsh7th/cmp-buffer')
  use('hrsh7th/cmp-path')
  use('hrsh7th/cmp-cmdline')
  use('hrsh7th/cmp-nvim-lsp-document-symbol')
  use('saadparwaiz1/cmp_luasnip')
  use('f3fora/cmp-spell')
  use('hrsh7th/cmp-emoji')
  use('L3MON4D3/LuaSnip')
  use('petertriho/cmp-git')
  use('rafamadriz/friendly-snippets')
  use('windwp/nvim-autopairs')

  use('EdenEast/nightfox.nvim')
  use { 'rebelot/kanagawa.nvim', opt = true }
  use { 'Mofiqul/vscode.nvim', opt = true }
  use { 'cocopon/iceberg.vim', opt = true }
  use { 'catppuccin/nvim', opt = true }
  use { 'folke/tokyonight.nvim', opt = true }

  use('folke/which-key.nvim')

  use('tamago324/lir.nvim')
  use('tamago324/lir-git-status.nvim')

  use('haya14busa/vim-asterisk')
  use('kevinhwang91/nvim-hlslens')

  use('TimUntersberger/neogit')
  use('sindrets/diffview.nvim')
  use('lewis6991/gitsigns.nvim')

  use { 'haya14busa/vim-edgemotion', on = '<Plug>(edgemotion-' }

  use('kana/vim-textobj-user')
  use('kana/vim-textobj-entire')
  use('kana/vim-textobj-line')
  use('kana/vim-textobj-indent')
  use('Julian/vim-textobj-variable-segment')

  use('nvim-telescope/telescope.nvim')
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use('ahmedkhalf/project.nvim')
  use('natecraddock/telescope-zf-native.nvim')
  use('nvim-telescope/telescope-live-grep-args.nvim')

  use('ojroques/vim-oscyank')

  use { 'norcalli/nvim-colorizer.lua', opt = true }

  use('folke/todo-comments.nvim')

  use('rcarriga/nvim-notify')

  use {
    'iamcco/markdown-preview.nvim',
    ft = 'markdown',
    run = 'call mkdp#util#install()',
  }

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

  use('stevearc/dressing.nvim')
  use('rmagatti/auto-session')
  use('andymass/vim-matchup')

  use('rlane/pounce.nvim')
  use('tpope/vim-projectionist')
  vim.g.projectionist_heuristics = {
    ['*.lua'] = {
      ['*.lua'] = { alternate = { '{}_spec.lua' }, type = 'source' },
      ['*_spec.lua'] = { alternate = '{}.lua', type = 'test' },
    },
    ['*.ts'] = {
      ['*.ts'] = { alternate = { '{}.test.ts', '{}.spec.ts' }, type = 'source' },
      ['*.test.ts'] = { alternate = '{}.ts', type = 'test' },
      ['*.spec.ts'] = { alternate = '{}.ts', type = 'test' },
    },
    ['*.tsx'] = {
      ['*.tsx'] = { alternate = { '{}.test.tsx', '{}.spec.tsx' }, type = 'source' },
      ['*.test.tsx'] = { alternate = '{}.tsx', type = 'test' },
      ['*.spec.tsx'] = { alternate = '{}.tsx', type = 'test' },
    },
    ['*.py'] = {
      ['*.py'] = { alternate = { 'test_{}.py' }, type = 'source' },
      ['test_*.py'] = { alternate = { '{}.py' }, type = 'test' },
    },
  }
  vim.keymap.set('n', '<LocalLeader>a', '<Cmd>A<CR>')
  vim.keymap.set('n', '<LocalLeader>Av', '<Cmd>AV<CR>')
  vim.keymap.set('n', '<LocalLeader>As', '<Cmd>AS<CR>')

  use('vim-test/vim-test')
  vim.g['test#strategy'] = 'harpoon'
  vim.g['test#harpoon_term'] = 1

  vim.keymap.set('n', '<LocalLeader>tn', '<Cmd>TestNearest<CR>')
  vim.keymap.set('n', '<LocalLeader>tf', '<Cmd>TestFile<CR>')
  vim.keymap.set('n', '<LocalLeader>ts', '<Cmd>TestSuite<CR>')
  vim.keymap.set('n', '<LocalLeader>tv', '<Cmd>TestVisit<CR>')

  use('gpanders/editorconfig.nvim')
  use('ThePrimeagen/harpoon')
  use('bkad/CamelCaseMotion')
  use { 'kana/vim-smartword', on = 'VimEnter' }
  use('antoinemadec/FixCursorHold.nvim')
  use('kosayoda/nvim-lightbulb')
  use('akinsho/git-conflict.nvim')
  use('gbprod/yanky.nvim')
  use('tpope/vim-repeat')
  use('AckslD/nvim-trevJ.lua')
  use { 'rainbowhxch/accelerated-jk.nvim', on = '<Plug>(accelerated_jk_' }
  use { 'psliwka/vim-dirtytalk', run = ':DirtytalkUpdate' }
  use('rebelot/heirline.nvim')
  use('lambdalisue/suda.vim')
  use('johmsalas/text-case.nvim')
end)

local sync = function()
  local names = jetpack.names()
  if not vim.tbl_isempty(names) then
    for _, name in ipairs(names) do
      if not jetpack.tap(name) then
        jetpack.sync()
        if bootstrapping then
          vim.cmd('quitall!')
        end
        break
      end
    end
  end
end

local group = vim.api.nvim_create_augroup('jetpack', { clear = true })
vim.api.nvim_create_autocmd('VimEnter', {
  group = group,
  callback = sync,
})
vim.api.nvim_create_autocmd('BufWritePost', {
  group = group,
  pattern = 'plugins.lua',
  callback = sync,
})
