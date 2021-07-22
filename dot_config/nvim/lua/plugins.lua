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
    config = function()
      require('zero').setup()
    end,
  }

  use {
    'monaqa/dial.nvim',
    config = function()
      local dial = require 'dial'
      dial.augends['custom#boolean'] = dial.common.enum_cyclic { name = 'boolean', strlist = { 'true', 'false' } }
      table.insert(dial.config.searchlist.normal, 'custom#boolean')

      vim.api.nvim_set_keymap('n', '<C-a>', '<Plug>(dial-increment)', { silent = true })
      vim.api.nvim_set_keymap('n', '<C-x>', '<Plug>(dial-decrement)', { silent = true })
      vim.api.nvim_set_keymap('n', '<C-a>', '<Plug>(dial-increment)', { silent = true })
      vim.api.nvim_set_keymap('n', '<C-x>', '<Plug>(dial-decrement)', { silent = true })
      vim.api.nvim_set_keymap('v', '<C-a>', '<Plug>(dial-increment-additional)', { silent = true })
      vim.api.nvim_set_keymap('v', '<C-x>', '<Plug>(dial-decrement-additional)', { silent = true })
    end,
  }

  use 'thinca/vim-prettyprint'

  use 'tyru/capture.vim'

  use {
    'tyru/open-browser.vim',
    setup = function()
      vim.api.nvim_set_keymap('n', 'gx', '<Plug>(openbrowser-smart-search)', { silent = true })
      vim.api.nvim_set_keymap('v', 'gx', '<Plug>(openbrowser-smart-search)', { silent = true })
    end,
  }

  use {
    'hrsh7th/vim-eft',
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
    'rafamadriz/friendly-snippets',
    {
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
    },
    {
      'hrsh7th/nvim-cmp',
      requires = {
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-emoji',
        'saadparwaiz1/cmp_luasnip',
      },
      config = function()
        require 'config.cmp'
      end,
    },
    {
      'windwp/nvim-autopairs',
      after = 'nvim-cmp',
      config = function()
        require('nvim-autopairs').setup { enable_check_bracket_line = false, fast_wrap = {} }
        require('nvim-autopairs.completion.cmp').setup {
          map_cr = true, --  map <CR> on insert mode
          map_complete = true, -- it will auto insert `(` after select function or method item
          auto_select = true, -- automatically select the first item
        }
      end,
    },
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
    config = function()
      require('trouble').setup {
        auto_close = true,
      }

      local opts = { noremap = true, silent = true }
      vim.api.nvim_set_keymap('n', '<leader>xx', '<Cmd>TroubleToggle<CR>', opts)
      vim.api.nvim_set_keymap('n', '<leader>xw', '<Cmd>Trouble lsp_workspace_diagnostics<CR>', opts)
      vim.api.nvim_set_keymap('n', '<leader>xd', '<Cmd>Trouble lsp_document_diagnostics<CR>', opts)
      vim.api.nvim_set_keymap('n', '<leader>xl', '<Cmd>Trouble loclist<CR>', opts)
      vim.api.nvim_set_keymap('n', '<leader>xq', '<Cmd>Trouble quickfix<CR>', opts)
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
    config = function()
      require 'config.toggleterm'
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

  use 'tversteeg/registers.nvim'

  use {
    'haya14busa/vim-edgemotion',
    setup = function()
      vim.api.nvim_set_keymap('n', '<C-j>', '<Plug>(edgemotion-j)', { silent = true })
      vim.api.nvim_set_keymap('x', '<C-j>', '<Plug>(edgemotion-j)', { silent = true })
      vim.api.nvim_set_keymap('n', '<C-k>', '<Plug>(edgemotion-k)', { silent = true })
      vim.api.nvim_set_keymap('x', '<C-k>', '<Plug>(edgemotion-k)', { silent = true })
    end,
  }

  use { 'kana/vim-textobj-user', 'kana/vim-textobj-entire', 'kana/vim-textobj-line' }

  use {
    'winston0410/smart-cursor.nvim',
    setup = function()
      vim.api.nvim_set_keymap(
        'n',
        'o',
        'o<cmd>lua require("smart-cursor").indent_cursor()<CR>',
        { noremap = true, silent = true }
      )
    end,
  }

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
      { 'nvim-lua/popup.nvim' },
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
    config = function()
      require 'config.altercmd'
    end,
  }

  use {
    'michaelb/sniprun',
    run = 'bash ./install.sh',
    config = function()
      require('sniprun').setup {
        selected_interpreters = { 'Lua_nvim' }, --" use those instead of the default for the current filetype
      }

      vim.api.nvim_set_keymap('v', '<Leader>sr', '<Plug>SnipRun', { silent = true })
      vim.api.nvim_set_keymap('n', '<Leader>sr', '<Plug>SnipRun', { silent = true })
      vim.api.nvim_set_keymap('n', '<Leader>so', '<Plug>SnipRunOperator', { silent = true })
      vim.api.nvim_set_keymap('n', '<Leader>sc', '<Plug>SnipClose', { silent = true })
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
    config = function()
      require('todo-comments').setup {}
      vim.api.nvim_set_keymap('n', '<Leader>tq', '<Cmd>TodoQuickFix<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<Leader>tt', '<Cmd>TodoTrouble<CR>', { noremap = true, silent = true })
    end,
  }

  use {
    's1n7ax/nvim-comment-frame',
    requires = { 'nvim-treesitter' },
    config = function()
      require('nvim-comment-frame').setup {}
    end,
  }

  use {
    'folke/persistence.nvim',
    event = 'BufReadPre', -- this will only start session saving when an actual file was opened
    module = 'persistence',
    setup = function()
      -- restore the session for the current directory
      vim.api.nvim_set_keymap(
        'n',
        '<leader>ps',
        [[<cmd>lua require("persistence").load()<cr>]],
        { noremap = true, silent = true }
      )
      -- restore the last session
      vim.api.nvim_set_keymap(
        'n',
        '<leader>pl',
        [[<cmd>lua require("persistence").load({ last = true })<cr>]],
        { noremap = true, silent = true }
      )
      -- stop Persistence => session won't be saved on exit
      vim.api.nvim_set_keymap(
        'n',
        '<leader>pd',
        [[<cmd>lua require("persistence").stop()<cr>]],
        { noremap = true, silent = true }
      )
      -- vim.cmd 'autocmd mine VimEnter * nested lua require("persistence").load()'
    end,
    config = function()
      require('persistence').setup()
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
        timeout = 3000,
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

  use 'jose-elias-alvarez/nvim-lsp-ts-utils'

  use {
    'lukas-reineke/headlines.nvim',
    config = function()
      require('headlines').setup()
    end,
  }

  use {
    'vuki656/package-info.nvim',
    requires = 'MunifTanjim/nui.nvim',
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
    config = function()
      require('goto-preview').setup {
        default_mappings = true,
      }
    end,
  }

  use {
    'iamcco/markdown-preview.nvim',
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
end

function M.setup()
  bootstrap()
  require('packer').startup {
    plugins,
    config = config,
  }
end

return M
