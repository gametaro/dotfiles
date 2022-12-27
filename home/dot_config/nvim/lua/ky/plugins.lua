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
  {
    'zbirenbaum/neodim',
    event = 'LspAttach',
    config = function()
      require('neodim').setup({
        hide = {
          virtual_text = false,
          signs = false,
          underline = false,
        },
      })
    end,
  },
  { 'norcalli/nvim-colorizer.lua' },
  { 'mtdl9/vim-log-highlighting' },
  { 'itchyny/vim-highlighturl', event = 'BufReadPost' },
  {
    'RRethy/vim-illuminate',
    event = 'BufReadPost',
    config = function()
      require('illuminate').configure({
        modes_denylist = { 'i' },
        filetypes_denylist = { 'qf' },
      })
    end,
  },
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
  {
    'andymass/vim-matchup',
    event = 'BufReadPost',
    init = function()
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_deferred_hide_delay = 300
      vim.g.matchup_matchparen_offscreen = { method = 'popup' }
    end,
  },
  {
    'ojroques/nvim-osc52',
    init = function()
      vim.keymap.set('n', '<LocalLeader>y', function()
        return require('osc52').copy_operator()
      end, { expr = true })
      vim.keymap.set('x', '<LocalLeader>y', function()
        require('osc52').copy_visual()
      end)
    end,
  },
  { 'johmsalas/text-case.nvim', config = true },
  {
    'Wansmer/treesj',
    cmd = 'TSJToggle',
    init = function()
      vim.keymap.set('n', '<LocalLeader>j', vim.cmd.TSJToggle)
    end,
    config = function()
      require('treesj').setup({
        use_default_keymaps = false,
      })
    end,
  },
  {
    'kylechui/nvim-surround',
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup({
        move_cursor = false,
      })
    end,
  },
  {
    'smjonas/live-command.nvim',
    event = 'CmdlineEnter',
    config = function()
      require('live-command').setup({
        commands = {
          Norm = { cmd = 'norm' },
        },
      })
    end,
  },
  { 'axelvc/template-string.nvim', enabled = false, config = true },
  {
    'cshuaimin/ssr.nvim',
    enabled = false,
    config = function()
      require('ssr').setup({
        min_width = 50,
        min_height = 5,
        keymaps = {
          close = 'q',
          next_match = 'n',
          prev_match = 'N',
          replace_all = '<LocalLeader><CR>',
        },
      })
      vim.keymap.set('n', '<LocalLeader>rs', require('ssr').open)
    end,
  },

  { 'smjonas/inc-rename.nvim', cmd = 'IncRename', config = true },
  {
    'kosayoda/nvim-lightbulb',
    event = 'LspAttach',
    config = function()
      require('nvim-lightbulb').setup({
        autocmd = { enabled = true },
      })
    end,
  },

  -- Completion/Snippets
  {
    'danymat/neogen',
    cmd = 'Neogen',
    init = function()
      vim.keymap.set('n', '<LocalLeader>nf', function()
        require('neogen').generate()
      end)
      vim.keymap.set('n', '<LocalLeader>nt', function()
        require('neogen').generate({ type = 'type' })
      end)
      vim.keymap.set('n', '<LocalLeader>nc', function()
        require('neogen').generate({ type = 'class' })
      end)
      vim.keymap.set('n', '<LocalLeader>nF', function()
        require('neogen').generate({ type = 'file' })
      end)
    end,
    config = function()
      require('neogen').setup({ snippet_engine = 'luasnip' })
    end,
  },

  -- ColorScheme
  { 'EdenEast/nightfox.nvim' },
  { 'rebelot/kanagawa.nvim' },
  { 'Mofiqul/vscode.nvim' },
  { 'cocopon/iceberg.vim' },
  { 'catppuccin/nvim' },
  { 'folke/tokyonight.nvim' },

  -- Keybinding
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      require('which-key').setup({
        plugins = {
          marks = false,
          spelling = {
            enabled = true,
          },
        },
        show_help = false,
        show_keys = false,
      })
    end,
  },

  -- Search
  {
    'haya14busa/vim-asterisk',
    keys = {
      { '*', mode = '' },
      { '#', mode = '' },
      { 'g*', mode = '' },
      { 'g#', mode = '' },
    },
    config = function()
      vim.g['asterisk#keeppos'] = 1
      vim.keymap.set('', '*', '<Plug>(asterisk-z*)')
      vim.keymap.set('', '#', '<Plug>(asterisk-z#)')
      vim.keymap.set('', 'g*', '<Plug>(asterisk-gz*)')
      vim.keymap.set('', 'g#', '<Plug>(asterisk-gz#)')
    end,
  },

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
  {
    'rhysd/git-messenger.vim',
    keys = { '<LocalLeader>gm' },
    config = function()
      vim.g.git_messenger_floating_win_opts = { border = require('ky.ui').border }
      vim.g.git_messenger_include_diff = 'current'
      vim.g.git_messenger_popup_content_margins = false

      vim.keymap.set('n', '<LocalLeader>gm', '<Plug>(git-messenger)')
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'gitmessengerpopup',
        callback = function()
          vim.opt_local.winbar = nil
        end,
      })
    end,
  },
  { 'akinsho/git-conflict.nvim', event = 'BufReadPost', config = true },
  {
    'hotwatermorning/auto-git-diff',
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('mine_auto_git_diff', {}),
        pattern = 'gitrebase',
        callback = function(a)
          vim.keymap.set(
            'n',
            '<C-l>',
            '<Plug>(auto_git_diff_scroll_manual_update)',
            { buffer = a.buf }
          )
          vim.keymap.set('n', '<C-d>', '<Plug>(auto_git_diff_scroll_down_half)', { buffer = a.buf })
          vim.keymap.set('n', '<C-u>', '<Plug>(auto_git_diff_scroll_up_half)', { buffer = a.buf })
        end,
      })
    end,
  },
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
  {
    'gametaro/pounce.nvim',
    branch = 'cword',
    cmd = 'Pounce',
    init = function()
      vim.keymap.set({ 'n', 'x' }, 's', '')
      vim.keymap.set({ 'n', 'x' }, 's', vim.cmd.Pounce)
      vim.keymap.set({ 'n', 'x' }, '<LocalLeader>s', vim.cmd.PounceCword)
      vim.keymap.set({ 'n', 'x', 'o' }, 'S', vim.cmd.PounceRepeat)
      vim.keymap.set('o', 'gs', vim.cmd.Pounce)
    end,
  },
  {
    'hrsh7th/vim-eft',
    keys = {
      { 'f', mode = { 'n', 'x', 'o' } },
      { 't', mode = { 'n', 'x', 'o' } },
      { 'F', mode = { 'n', 'x', 'o' } },
      { 'T', mode = { 'n', 'x', 'o' } },
    },
    config = function()
      for _, v in ipairs({ 'f', 'F', 't', 'T' }) do
        vim.keymap.set({ 'n', 'x', 'o' }, v, string.format('<Plug>(eft-%s-repeatable)', v))
      end
    end,
  },
  {
    'rainbowhxch/accelerated-jk.nvim',
    keys = { 'j', 'k' },
    config = function()
      for _, v in ipairs({ 'j', 'k' }) do
        vim.keymap.set('n', v, function()
          return vim.v.count == 0 and string.format('<Plug>(accelerated_jk_g%s)', v)
            or string.format('<Plug>(accelerated_jk_%s)', v)
        end, { expr = true })
      end
    end,
  },

  -- Comment
  -- {
  --   'numToStr/Comment.nvim',
  --   require('Comment').setup({
  --     ignore = '^$',
  --     pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
  --   }),
  -- },
  {
    'folke/todo-comments.nvim',
    init = function()
      vim.keymap.set('n', '<LocalLeader>tq', vim.cmd.TodoQuickFix)
      vim.keymap.set('n', '<LocalLeader>tl', vim.cmd.TodoLocList)
      vim.keymap.set('n', ']t', function()
        require('todo-comments').jump_next()
      end, { desc = 'Next todo comment' })

      vim.keymap.set('n', '[t', function()
        require('todo-comments').jump_prev()
      end, { desc = 'Previous todo comment' })
    end,
    config = true,
  },

  -- Project
  {
    'ahmedkhalf/project.nvim',
    enabled = false,
    config = function()
      require('project_nvim').setup({
        manual_mode = true,
        ignore_lsp = { 'null-ls' },
      })
      require('telescope').load_extension('projects')
      vim.keymap.set('n', '<LocalLeader>fp', '<Cmd>Telescope projects<CR>')

      local group = vim.api.nvim_create_augroup('mine__project', { clear = true })

      vim.api.nvim_create_autocmd({ 'BufEnter', 'VimEnter' }, {
        group = group,
        nested = true,
        callback = function()
          if vim.tbl_contains({ 'nofile', 'prompt' }, vim.bo.buftype) then
            return
          end
          if vim.tbl_contains({ 'help', 'qf' }, vim.bo.filetype) then
            return
          end
          local root = require('project_nvim.project').get_project_root()
          if root then
            vim.cmd.tcd({ root, mods = { silent = true } })
          end
        end,
      })

      vim.api.nvim_create_autocmd('VimLeavePre', {
        group = group,
        callback = function()
          require('project_nvim.utils.history').write_projects_to_history()
        end,
      })
    end,
  },
  {
    'tpope/vim-projectionist',
    init = function()
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
      vim.keymap.set('n', '<LocalLeader>a', vim.cmd.A)
      vim.keymap.set('n', '<LocalLeader>Av', vim.cmd.AV)
      vim.keymap.set('n', '<LocalLeader>As', vim.cmd.AS)
    end,
  },

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
    'kevinhwang91/nvim-fundo',
    dependencies = 'kevinhwang91/promise-async',
    build = function()
      require('fundo').install()
    end,
    lazy = false,
    config = true,
  },
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
