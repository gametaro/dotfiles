local M = {}

local function bootstrap()
  local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/opt/packer.nvim'
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system { 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path }
  end
  vim.cmd 'packadd packer.nvim'
end

local config = {
  profile = {
    enable = true,
    threshold = 1,
  },
}

local function plugins(use)
  use { 'wbthomason/packer.nvim', opt = true }

  use 'machakann/vim-sandwich'

  use {
    'numToStr/Comment.nvim',
    requires = { 'JoosepAlviste/nvim-ts-context-commentstring' },
    keys = { 'g' },
    config = function()
      require('Comment').setup {
        mappings = {
          extended = true,
        },
        pre_hook = function()
          return require('ts_context_commentstring.internal').calculate_commentstring()
        end,
      }
    end,
  }

  use 'kevinhwang91/nvim-bqf'

  use {
    'gabrielpoca/replacer.nvim',
    setup = function()
      vim.api.nvim_set_keymap('n', '<Leader>R', '<Cmd>lua require("replacer").run()<cr>', { silent = true })
    end,
  }

  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('indent_blankline').setup {
        buftype_exclude = { 'nofile', 'terminal', 'help' },
        filetype_exclude = { 'packer', 'Trouble' },
      }
    end,
  }

  use {
    'yuki-yano/zero.nvim',
    keys = { '0' },
    config = function()
      require('zero').setup()
    end,
  }

  use {
    'monaqa/dial.nvim',
    keys = { '<Plug>(dial-' },
    setup = function()
      vim.api.nvim_set_keymap('n', '<C-a>', '<Plug>(dial-increment)', { silent = true })
      vim.api.nvim_set_keymap('n', '<C-x>', '<Plug>(dial-decrement)', { silent = true })
      vim.api.nvim_set_keymap('n', '<C-a>', '<Plug>(dial-increment)', { silent = true })
      vim.api.nvim_set_keymap('n', '<C-x>', '<Plug>(dial-decrement)', { silent = true })
      vim.api.nvim_set_keymap('v', '<C-a>', '<Plug>(dial-increment-additional)', { silent = true })
      vim.api.nvim_set_keymap('v', '<C-x>', '<Plug>(dial-decrement-additional)', { silent = true })
    end,
    config = function()
      local dial = require 'dial'
      dial.augends['custom#boolean'] = dial.common.enum_cyclic { name = 'boolean', strlist = { 'true', 'false' } }
      table.insert(dial.config.searchlist.normal, 'custom#boolean')
    end,
  }

  use { 'thinca/vim-prettyprint', event = 'CmdlineEnter' }

  use { 'tyru/capture.vim', event = 'CmdlineEnter' }

  use {
    'tyru/open-browser.vim',
    keys = { '<Plug>(openbrowser-smart-search)' },
    setup = function()
      vim.api.nvim_set_keymap('n', 'gx', '<Plug>(openbrowser-smart-search)', { silent = true })
      vim.api.nvim_set_keymap('v', 'gx', '<Plug>(openbrowser-smart-search)', { silent = true })
    end,
  }

  use {
    'hrsh7th/vim-eft',
    keys = { '<Plug>(eft-' },
    setup = function()
      vim.api.nvim_set_keymap('n', ';', '<Plug>(eft-repeat)', {})
      vim.api.nvim_set_keymap('x', ';', '<Plug>(eft-repeat)', {})
      vim.api.nvim_set_keymap('n', 'f', '<Plug>(eft-f)', {})
      vim.api.nvim_set_keymap('x', 'f', '<Plug>(eft-f)', {})
      vim.api.nvim_set_keymap('o', 'f', '<Plug>(eft-f)', {})
      vim.api.nvim_set_keymap('n', 'F', '<Plug>(eft-F)', {})
      vim.api.nvim_set_keymap('x', 'F', '<Plug>(eft-F)', {})
      vim.api.nvim_set_keymap('o', 'F', '<Plug>(eft-F)', {})
      vim.api.nvim_set_keymap('n', 't', '<Plug>(eft-t)', {})
      vim.api.nvim_set_keymap('x', 't', '<Plug>(eft-t)', {})
      vim.api.nvim_set_keymap('o', 't', '<Plug>(eft-t)', {})
      vim.api.nvim_set_keymap('n', 'T', '<Plug>(eft-T)', {})
      vim.api.nvim_set_keymap('x', 'T', '<Plug>(eft-T)', {})
      vim.api.nvim_set_keymap('o', 'T', '<Plug>(eft-T)', {})
    end,
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    requires = {
      { 'nvim-treesitter/nvim-treesitter-refactor' },
      { 'nvim-treesitter/nvim-treesitter-textobjects' },
      { 'p00f/nvim-ts-rainbow' },
      { 'windwp/nvim-ts-autotag' },
      { 'RRethy/nvim-treesitter-textsubjects' },
    },
    run = ':TSUpdate',
    config = function()
      require 'config.treesitter'
    end,
  }

  use {
    'kana/vim-operator-replace',
    requires = { 'kana/vim-operator-user' },
    keys = { '<Plug>(operator-replace)' },
    setup = function()
      vim.api.nvim_set_keymap('n', 'R', '<Plug>(operator-replace)', { silent = true })
      vim.api.nvim_set_keymap('x', 'R', '<Plug>(operator-replace)', { silent = true })
    end,
  }

  use 'kana/vim-niceblock'

  use {
    'neovim/nvim-lspconfig',
    requires = {
      { 'williamboman/nvim-lsp-installer' },
      { 'ray-x/lsp_signature.nvim' },
      { 'folke/lua-dev.nvim' },
      { 'jose-elias-alvarez/null-ls.nvim' },
      { 'onsails/lspkind-nvim' },
    },
    config = function()
      require 'lsp'
    end,
  }

  use {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    requires = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-emoji', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp-document-symbol', after = 'nvim-cmp' },
      { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
      { 'rafamadriz/friendly-snippets', after = 'nvim-cmp' },
    },
    config = function()
      require 'config.cmp'
    end,
  }

  use {
    'L3MON4D3/LuaSnip',
    wants = 'friendly-snippets',
    config = function()
      require('luasnip').config.set_config {
        updateevents = 'TextChanged,TextChangedI',
        delete_check_events = 'TextChanged',
        enable_autosnippets = true,
      }
      require('luasnip/loaders/from_vscode').load()
    end,
  }

  use {
    'windwp/nvim-autopairs',
    after = 'nvim-cmp',
    config = function()
      require('nvim-autopairs').setup { enable_check_bracket_line = false, fast_wrap = {} }
    end,
  }

  use {
    'folke/tokyonight.nvim',
    'projekt0n/github-nvim-theme',
    'marko-cerovac/material.nvim',
    'EdenEast/nightfox.nvim',
  }

  use {
    'windwp/windline.nvim',
    config = function()
      require 'config.windline'
    end,
  }

  use {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup {}
    end,
  }

  use {
    'folke/trouble.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    cmd = { 'Trouble' },
    setup = function()
      local opts = { noremap = true, silent = true }
      vim.api.nvim_set_keymap('n', '<leader>xx', '<Cmd>Trouble<CR>', opts)
      vim.api.nvim_set_keymap('n', '<leader>xw', '<Cmd>Trouble lsp_workspace_diagnostics<CR>', opts)
      vim.api.nvim_set_keymap('n', '<leader>xd', '<Cmd>Trouble lsp_document_diagnostics<CR>', opts)
      vim.api.nvim_set_keymap('n', '<leader>xl', '<Cmd>Trouble loclist<CR>', opts)
      vim.api.nvim_set_keymap('n', '<leader>xq', '<Cmd>Trouble quickfix<CR>', opts)
      vim.api.nvim_set_keymap('n', 'gR', '<cmd>Trouble lsp_references<cr>', opts)
    end,
    config = function()
      require('trouble').setup {
        auto_close = true,
      }
    end,
  }

  use {
    'romgrk/barbar.nvim',
    setup = function()
      local opts = { noremap = true, silent = true }
      vim.api.nvim_set_keymap('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
      vim.api.nvim_set_keymap('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
      vim.api.nvim_set_keymap('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
      vim.api.nvim_set_keymap('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)
      vim.api.nvim_set_keymap('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
      vim.api.nvim_set_keymap('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
      vim.api.nvim_set_keymap('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
      vim.api.nvim_set_keymap('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
      vim.api.nvim_set_keymap('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
      vim.api.nvim_set_keymap('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
      vim.api.nvim_set_keymap('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
      vim.api.nvim_set_keymap('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
      vim.api.nvim_set_keymap('n', '<A-9>', '<Cmd>BufferLast<CR>', opts)
      vim.api.nvim_set_keymap('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
      vim.api.nvim_set_keymap('n', '<A-w>', '<Cmd>BufferWipeout<CR>', opts)
      vim.api.nvim_set_keymap('n', '<A-o>', '<Cmd>BufferCloseAllButCurrent<CR>', opts)
      vim.api.nvim_set_keymap('n', '<A-r>', '<Cmd>BufferCloseBuffersRight<CR>', opts)
      vim.api.nvim_set_keymap('n', '<A-s>', '<Cmd>BufferPick<CR>', opts)
      vim.api.nvim_set_keymap('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)

      vim.g.bufferline = {
        animation = false,
      }
    end,
  }

  use {
    'akinsho/toggleterm.nvim',
    cmd = { 'ToggleTerm' },
    setup = function()
      vim.g.toggleterm_terminal_mapping = [[<C-\>]]

      vim.api.nvim_set_keymap(
        'n',
        [[<C-\>]],
        '<Cmd>execute v:count1 . "ToggleTerm"<CR>',
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        'i',
        [[<C-\>]],
        '<Cmd>execute v:count1 . "ToggleTerm"<CR>',
        { noremap = true, silent = true }
      )
    end,
    config = function()
      require('toggleterm').setup {
        size = vim.fn.float2nr(vim.o.lines * 0.3),
        open_mapping = [[<c-\>]],
        shade_terminals = false,
      }

      function _G.set_terminal_keymaps()
        local opts = { noremap = true }
        vim.api.nvim_buf_set_keymap(0, 't', '<Esc>', [[<C-\><C-n>]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<M-h>', [[<C-\><C-n><C-W>h]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<M-j>', [[<C-\><C-n><C-W>j]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<M-k>', [[<C-\><C-n><C-W>k]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<M-l>', [[<C-\><C-n><C-W>l]], opts)
      end

      vim.cmd 'autocmd! TermOpen term://* lua set_terminal_keymaps()'
    end,
  }

  use {
    'kyazdani42/nvim-tree.lua',
    config = function()
      require 'config.tree'
    end,
  }

  use {
    'kevinhwang91/nvim-hlslens',
    requires = { 'haya14busa/vim-asterisk' },
    config = function()
      require('hlslens').setup { calm_down = true }
      local opts = { noremap = true, silent = true }
      vim.api.nvim_set_keymap(
        'n',
        'n',
        [[<Cmd>lua vim.cmd('norm! ' .. vim.v.count1 .. 'nzz') require('hlslens').start()<CR>]],
        opts
      )
      vim.api.nvim_set_keymap(
        'n',
        'N',
        [[<Cmd>lua vim.cmd('norm! ' .. vim.v.count1 .. 'Nzz') require('hlslens').start()<CR>]],
        opts
      )
      vim.api.nvim_set_keymap('', '*', [[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]], {})
      vim.api.nvim_set_keymap('', '#', [[<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>]], {})
      vim.api.nvim_set_keymap('', 'g*', [[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]], {})
      vim.api.nvim_set_keymap('', 'g#', [[<Plug>(asterisk-gz#)<Cmd>lua require('hlslens').start()<CR>]], {})
    end,
  }

  use {
    'TimUntersberger/neogit',
    requires = {
      { 'nvim-lua/plenary.nvim' },
    },
    cmd = { 'Neogit' },
    config = function()
      require('neogit').setup {
        disable_hint = true,
        disable_commit_confirmation = true,
        disable_builtin_notifications = true,
        integrations = { diffview = true },
      }
    end,
  }

  use {
    'sindrets/diffview.nvim',
    config = function()
      require('diffview').setup {
        enhanced_diff_hl = true,
        key_bindings = {
          view = {
            ['q'] = '<Cmd>DiffviewClose<CR>',
          },
          file_panel = {
            ['q'] = '<Cmd>DiffviewClose<CR>',
          },
          file_history_panel = {
            ['q'] = '<Cmd>DiffviewClose<CR>',
          },
        },
      }
    end,
  }

  use {
    'lewis6991/gitsigns.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require 'config.gitsigns'
    end,
  }

  use { 'tversteeg/registers.nvim', cmd = { 'Registers' }, keys = { '<Plug>(registers)' } }

  use {
    'haya14busa/vim-edgemotion',
    keys = { '<Plug>(edgemotion-' },
    setup = function()
      vim.api.nvim_set_keymap('n', '<C-j>', '<Plug>(edgemotion-j)', { silent = true })
      vim.api.nvim_set_keymap('x', '<C-j>', '<Plug>(edgemotion-j)', { silent = true })
      vim.api.nvim_set_keymap('n', '<C-k>', '<Plug>(edgemotion-k)', { silent = true })
      vim.api.nvim_set_keymap('x', '<C-k>', '<Plug>(edgemotion-k)', { silent = true })
    end,
  }

  use { 'kana/vim-textobj-user', 'kana/vim-textobj-entire', 'kana/vim-textobj-line' }

  use {
    'ahmedkhalf/project.nvim',
    config = function()
      require('project_nvim').setup {}
      require('telescope').load_extension 'projects'
      vim.api.nvim_set_keymap('n', '<leader>fp', '<Cmd>Telescope projects<CR>', { noremap = true, silent = true })
    end,
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-frecency.nvim', requires = { 'tami5/sqlite.lua' } },
      {
        'nvim-telescope/telescope-smart-history.nvim',
        requires = { 'tami5/sqlite.lua' },
        run = function()
          os.execute 'mkdir -p ~/.local/share/nvim/databases'
        end,
      },
    },
    config = function()
      require 'config.telescope'
    end,
  }

  use {
    'kana/vim-altercmd',
    event = { 'CmdlineEnter' },
    config = function()
      require 'config.altercmd'
    end,
  }

  use {
    'michaelb/sniprun',
    keys = { '<Plug>Snip' },
    run = 'bash ./install.sh',
    setup = function()
      vim.api.nvim_set_keymap('v', '<Leader>sr', '<Plug>SnipRun', { silent = true })
      vim.api.nvim_set_keymap('n', '<Leader>sr', '<Plug>SnipRun', { silent = true })
      vim.api.nvim_set_keymap('n', '<Leader>so', '<Plug>SnipRunOperator', { silent = true })
      vim.api.nvim_set_keymap('n', '<Leader>sc', '<Plug>SnipClose', { silent = true })
    end,
    config = function()
      require('sniprun').setup {
        selected_interpreters = { 'Lua_nvim' }, --" use those instead of the default for the current filetype
      }
    end,
  }

  use {
    'dstein64/nvim-scrollview',
    setup = function()
      vim.g.scrollview_current_only = 1
    end,
  }

  use {
    'kana/vim-submode',
    config = function()
      require 'config.submode'
    end,
  }

  use {
    'kevinhwang91/nvim-hclipboard',
    opt = true,
    config = function()
      require('hclipboard').start()
    end,
  }

  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  }

  use {
    'mfussenegger/nvim-dap',
    config = function()
      require 'config.dap'
    end,
  }

  use {
    'rcarriga/nvim-dap-ui',
    config = function()
      require('dapui').setup()
    end,
  }

  use {
    'folke/todo-comments.nvim',
    requires = 'nvim-lua/plenary.nvim',
    cmd = { 'TodoQuickFix', 'TodoTrouble' },
    setup = function()
      vim.api.nvim_set_keymap('n', '<Leader>tq', '<Cmd>TodoQuickFix<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<Leader>tt', '<Cmd>TodoTrouble<CR>', { noremap = true, silent = true })
    end,
    config = function()
      require('todo-comments').setup {}
    end,
  }

  use {
    'rmagatti/auto-session',
    config = function()
      require('auto-session').setup {
        auto_session_enabled = true,
        auto_save_enabled = true,
        auto_restore_enabled = true,
      }
    end,
  }

  use {
    'David-Kunz/treesitter-unit',
    setup = function()
      vim.api.nvim_set_keymap('x', 'iu', ':lua require"treesitter-unit".select()<CR>', { noremap = true })
      vim.api.nvim_set_keymap('x', 'au', ':lua require"treesitter-unit".select(true)<CR>', { noremap = true })
      vim.api.nvim_set_keymap('o', 'iu', ':<c-u>lua require"treesitter-unit".select()<CR>', { noremap = true })
      vim.api.nvim_set_keymap('o', 'au', ':<c-u>lua require"treesitter-unit".select(true)<CR>', { noremap = true })
    end,
  }

  use {
    'SmiteshP/nvim-gps',
    requires = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require('nvim-gps').setup {}
    end,
  }

  use {
    'rcarriga/nvim-notify',
    cond = function()
      return #vim.api.nvim_list_uis() > 0
    end,
    config = function()
      local notify = require 'notify'
      local icons = require('theme').icons
      notify.setup {
        timeout = 2000,
        icons = {
          ERROR = string.gsub(icons.error, '%s+', ''),
          WARN = string.gsub(icons.warn, '%s+', ''),
          INFO = string.gsub(icons.info, '%s+', ''),
        },
      }
      vim.notify = notify
    end,
  }

  use {
    'abecodes/tabout.nvim',
    wants = { 'nvim-treesitter' },
    after = { 'nvim-cmp' },
    config = function()
      require('tabout').setup {}
    end,
  }

  use 'lewis6991/impatient.nvim'

  use { 'jose-elias-alvarez/nvim-lsp-ts-utils', ft = { 'typescript', 'typescriptreact' } }

  use {
    'lukas-reineke/headlines.nvim',
    ft = { 'markdown' },
    config = function()
      require('headlines').setup()
    end,
  }

  use {
    'vuki656/package-info.nvim',
    requires = 'MunifTanjim/nui.nvim',
    keys = { '<leader>n' },
    setup = function()
      -- Show package versions
      vim.api.nvim_set_keymap(
        'n',
        '<leader>ns',
        ":lua require('package-info').show()<CR>",
        { silent = true, noremap = true }
      )
      -- Hide package versions
      vim.api.nvim_set_keymap(
        'n',
        '<leader>nh',
        ":lua require('package-info').hide()<CR>",
        { silent = true, noremap = true }
      )
      -- Update package on line
      vim.api.nvim_set_keymap(
        'n',
        '<leader>nu',
        ":lua require('package-info').update()<CR>",
        { silent = true, noremap = true }
      )
      -- Delete package on line
      vim.api.nvim_set_keymap(
        'n',
        '<leader>nd',
        ":lua require('package-info').delete()<CR>",
        { silent = true, noremap = true }
      )
      -- Install a new package
      vim.api.nvim_set_keymap(
        'n',
        '<leader>ni',
        ":lua require('package-info').install()<CR>",
        { silent = true, noremap = true }
      )
      -- Reinstall dependencies
      vim.api.nvim_set_keymap(
        'n',
        '<leader>nr',
        ":lua require('package-info').reinstall()<CR>",
        { silent = true, noremap = true }
      )
      -- Install a different package version
      vim.api.nvim_set_keymap(
        'n',
        '<leader>nc',
        ":lua require('package-info').change_version()<CR>",
        { silent = true, noremap = true }
      )
    end,
    config = function()
      require('package-info').setup {}
    end,
  }

  use {
    'rmagatti/goto-preview',
    setup = function()
      vim.api.nvim_set_keymap(
        'n',
        'gpd',
        "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
        { noremap = true }
      )
      vim.api.nvim_set_keymap(
        'n',
        'gpi',
        "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
        { noremap = true }
      )
      vim.api.nvim_set_keymap('n', 'q', "<cmd>lua require('goto-preview').close_all_win()<CR>", { noremap = true })
    end,
    config = function()
      require('goto-preview').setup {}
    end,
  }

  use {
    'iamcco/markdown-preview.nvim',
    ft = { 'markdown' },
    run = function()
      vim.fn['mkdp#util#install']()
    end,
  }

  use 'nathom/filetype.nvim'

  use {
    'https://gitlab.com/yorickpeterse/nvim-pqf.git',
    config = function()
      require('pqf').setup()
    end,
  }

  use {
    'chentau/marks.nvim',
    config = function()
      require('marks').setup {
        mappings = {
          delete_line = 'dml',
          delete_buf = 'dmb',
        },
      }
    end,
  }

  use {
    'github/copilot.vim',
    setup = function()
      vim.g.copilot_no_tab_map = true

      vim.api.nvim_set_keymap('i', '<C-j>', [[copilot#Accept("\<CR>")]], {
        noremap = true,
        script = true,
        expr = true,
      })
    end,
  }

  use 'b0o/schemastore.nvim'
end

function M.setup()
  bootstrap()
  require('packer').startup {
    plugins,
    config = config,
  }
end

return M
