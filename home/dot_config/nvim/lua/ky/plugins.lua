---check nvim is running on headless mode
---@return boolean
local not_headless = function()
  return #vim.api.nvim_list_uis() > 0
end

local bootstrap = function()
  local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
  if not vim.loop.fs_stat(install_path) then
    vim.fn.system {
      'git',
      'clone',
      '--depth',
      '1',
      'https://github.com/wbthomason/packer.nvim',
      install_path,
    }
  end
  vim.cmd('packadd packer.nvim')
end

local config = {
  profile = {
    enable = false,
    threshold = 1,
  },
  display = {
    -- open_fn = function()
    --   return require('packer.util').float { border = require('ky.theme').border }
    -- end,
    prompt_border = require('ky.theme').border,
  },
  max_jobs = jit.os == 'OSX' and 50 or nil,
}

local plugins = function(use)
  use { 'wbthomason/packer.nvim', opt = true }
  use('lewis6991/impatient.nvim')
  use('nvim-lua/plenary.nvim')
  use('kyazdani42/nvim-web-devicons')

  use {
    'machakann/vim-sandwich',
    event = { 'BufRead' },
    config = function()
      require('ky.config.sandwich')
    end,
  }

  use {
    'machakann/vim-swap',
    event = { 'BufRead' },
    setup = function()
      vim.g.swap_no_default_key_mappings = 1

      vim.keymap.set('n', 'g<', '<Plug>(swap-prev)')
      vim.keymap.set('n', 'g>', '<Plug>(swap-next)')
      vim.keymap.set({ 'o', 'x' }, 'i,', '<Plug>(swap-textobject-i)')
      vim.keymap.set({ 'o', 'x' }, 'a,', '<Plug>(swap-textobject-a)')
    end,
  }

  use {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    requires = {
      {
        'junegunn/fzf',
        run = function()
          if not_headless() then
            vim.fn['fzf#install']()
          end
        end,
      },
    },
    setup = function()
      vim.api.nvim_set_hl(0, 'BqfPreviewBorder', {
        default = true,
        link = 'FloatBorder',
      })
    end,
    config = function()
      require('bqf').setup {
        filter = {
          fzf = {
            extra_opts = { '--bind', 'ctrl-o:toggle-all', '--delimiter', '│' },
          },
        },
      }
    end,
  }

  use {
    'numToStr/Comment.nvim',
    keys = {
      { 'n', 'gc' },
      { 'x', 'gc' },
    },
    config = function()
      require('ky.config.comment')
    end,
  }

  use {
    'monaqa/dial.nvim',
    event = { 'BufRead' },
    config = function()
      require('ky.config.dial')
    end,
  }

  use {
    'thinca/vim-prettyprint',
    cmd = { 'PP', 'PrettyPrint' },
    setup = function()
      vim.api.nvim_create_user_command('PPGlobal', 'Capture PP g:', {})
      vim.api.nvim_create_user_command('PPBuffer', 'Capture PP b:', {})
    end,
  }

  use { 'tyru/capture.vim', cmd = 'Capture' }

  use {
    'tyru/open-browser.vim',
    keys = { '<Plug>(openbrowser-smart-search)' },
    setup = function()
      vim.keymap.set({ 'n', 'x' }, 'gx', '<Plug>(openbrowser-smart-search)')
    end,
  }

  use {
    'hrsh7th/vim-eft',
    keys = { '<Plug>(eft-' },
    setup = function()
      vim.keymap.set({ 'n', 'x', 'o' }, ':', '<Plug>(eft-repeat)')
      for _, v in ipairs { 'f', 'F', 't', 'T' } do
        vim.keymap.set({ 'n', 'x', 'o' }, v, string.format('<Plug>(eft-%s)', v))
      end
    end,
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    event = 'BufRead',
    requires = {
      { 'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter' },
      { 'p00f/nvim-ts-rainbow', after = 'nvim-treesitter' },
      { 'JoosepAlviste/nvim-ts-context-commentstring', after = 'nvim-treesitter' },
      { 'windwp/nvim-ts-autotag', after = 'nvim-treesitter' },
      { 'nvim-treesitter/playground', after = 'nvim-treesitter' },
    },
    run = function()
      if not_headless() then
        vim.cmd([[ TSUpdate ]])
      end
    end,
    config = function()
      require('ky.config.treesitter')
    end,
  }

  -- use {
  --   'kana/vim-operator-replace',
  --   requires = { 'kana/vim-operator-user' },
  --   keys = { '<Plug>(operator-replace)' },
  --   setup = function()
  --     vim.keymap.set({ 'n', 'x' }, '_', '<Plug>(operator-replace)')
  --   end,
  -- }

  use {
    'gbprod/substitute.nvim',
    setup = function()
      vim.keymap.set('n', 'S', function()
        require('substitute').operator()
      end)
      vim.keymap.set('x', 'S', function()
        require('substitute').visual()
      end)
      vim.keymap.set('n', 'X', function()
        require('substitute.exchange').operator()
      end)
      vim.keymap.set('x', 'X', function()
        require('substitute.exchange').visual()
      end)
      vim.keymap.set('n', 'Xc', function()
        require('substitute.exchange').cancel()
      end)
    end,
    config = function()
      require('substitute').setup {
        on_substitute = function(event)
          require('yanky').init_ring('p', event.register, event.count, event.vmode:match('[vV]'))
        end,
      }
    end,
  }

  use {
    'kana/vim-niceblock',
    keys = {
      { 'x', '<Plug>(niceblock-' },
    },
    setup = function()
      vim.g.niceblock_no_default_key_mappings = 1

      vim.keymap.set('x', 'A', '<Plug>(niceblock-A)')
      vim.keymap.set('x', 'I', '<Plug>(niceblock-I)')
    end,
  }

  use {
    'neovim/nvim-lspconfig',
    event = { 'BufRead' },
    requires = {
      { 'williamboman/nvim-lsp-installer' },
      { 'b0o/schemastore.nvim' },
      { 'jose-elias-alvarez/nvim-lsp-ts-utils' },
      {
        'lukas-reineke/lsp-format.nvim',
        config = function()
          require('lsp-format').setup {
            typescript = {
              exclude = { 'tsserver', 'eslint' },
            },
          }
        end,
      },
    },
    config = function()
      require('ky.lsp')
    end,
  }

  use {
    'jose-elias-alvarez/null-ls.nvim',
    event = { 'BufRead' },
    config = function()
      require('ky.lsp.null-ls')
    end,
  }

  use {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    requires = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp-document-symbol', after = 'nvim-cmp' },
      { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
      { 'f3fora/cmp-spell', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-emoji', after = 'nvim-cmp' },
      {
        'petertriho/cmp-git',
        after = 'nvim-cmp',
        config = function()
          require('cmp_git').setup {
            filetypes = { 'gitcommit', 'NeogitCommitMessage' },
          }
        end,
      },
      {
        'L3MON4D3/LuaSnip',
        requires = 'rafamadriz/friendly-snippets',
        config = function()
          require('ky.config.luasnip')
        end,
      },
    },
    config = function()
      require('ky.config.cmp')
    end,
  }

  use {
    'windwp/nvim-autopairs',
    after = 'nvim-cmp',
    config = function()
      require('ky.config.autopairs')
    end,
  }

  use('EdenEast/nightfox.nvim')
  use('rebelot/kanagawa.nvim')
  use('Mofiqul/vscode.nvim')

  use {
    'windwp/windline.nvim',
    disable = true,
    event = 'VimEnter',
    config = function()
      require('ky.config.windline')
    end,
  }

  use {
    'folke/which-key.nvim',
    event = 'BufRead',
    config = function()
      require('which-key').setup {
        plugins = {
          presets = {
            operators = false,
          },
          spelling = {
            enabled = true,
          },
        },
      }
    end,
  }

  -- use {
  --   'folke/trouble.nvim',
  --   requires = { 'kyazdani42/nvim-web-devicons' },
  --   keys = {
  --     { 'n', '<LocalLeader>x' },
  --   },
  --   cmd = { 'Trouble' },
  --   setup = function()
  --     vim.keymap.set('n', '<LocalLeader>xx', '<Cmd>Trouble<CR>')
  --     vim.keymap.set('n', '<LocalLeader>xw', '<Cmd>Trouble workspace_diagnostics<CR>')
  --     vim.keymap.set('n', '<LocalLeader>xd', '<Cmd>Trouble document_diagnostics<CR>')
  --     vim.keymap.set('n', '<LocalLeader>xl', '<Cmd>Trouble loclist<CR>')
  --     vim.keymap.set('n', '<LocalLeader>xq', '<Cmd>Trouble quickfix<CR>')
  --     vim.keymap.set('n', 'gR', '<Cmd>Trouble lsp_references<CR>')
  --   end,
  --   config = function()
  --     require('trouble').setup {
  --       auto_close = true,
  --     }
  --   end,
  -- }

  use {
    'tamago324/lir.nvim',
    event = { 'BufRead' },
    requires = {
      {
        'tamago324/lir-git-status.nvim',
        after = 'lir.nvim',
        config = function()
          require('lir.git_status').setup {
            show_ignored = false,
          }
        end,
      },
    },
    config = function()
      require('ky.config.lir')
    end,
  }

  use {
    'haya14busa/vim-asterisk',
    setup = function()
      vim.g['asterisk#keeppos'] = 1
    end,
  }

  use {
    'kevinhwang91/nvim-hlslens',
    after = 'vim-asterisk',
    setup = function()
      for _, v in ipairs { 'n', 'N' } do
        vim.keymap.set('n', v, function()
          local ok, msg = pcall(vim.cmd, 'normal! ' .. vim.v.count1 .. v)
          if ok then
            require('hlslens').start()
          else
            vim.notify(msg, vim.log.levels.INFO, { title = 'hlslens' })
          end
        end)
      end
      vim.keymap.set('', '*', '<Plug>(asterisk-z*)<Cmd>lua require("hlslens").start()<CR>')
      vim.keymap.set('', '#', '<Plug>(asterisk-z#)<Cmd>lua require("hlslens").start()<CR>')
      vim.keymap.set('', 'g*', '<Plug>(asterisk-gz*)<Cmd>lua require("hlslens").start()<CR>')
      vim.keymap.set('', 'g#', '<Plug>(asterisk-gz#)<Cmd>lua require("hlslens").start()<CR>')
    end,
    config = function()
      require('hlslens').setup { calm_down = true }
    end,
  }

  use {
    'TimUntersberger/neogit',
    requires = 'nvim-lua/plenary.nvim',
    cmd = { 'Neogit' },
    setup = function()
      vim.keymap.set('n', '<LocalLeader>gg', '<Cmd>Neogit<CR>')
      vim.keymap.set('n', '<LocalLeader>gG', '<Cmd>Neogit commit<CR>')

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'NeogitStatus',
        callback = function()
          vim.opt_local.list = false
        end,
      })

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'NeogitCommitMessage',
        callback = function()
          vim.opt_local.spell = true
          vim.opt_local.formatoptions:append { 't' }
          vim.opt_local.textwidth = 72
        end,
      })
    end,
    config = function()
      require('neogit').setup {
        disable_builtin_notifications = true,
        disable_commit_confirmation = true,
        disable_hint = true,
        disable_insert_on_commit = false,
        integrations = { diffview = true },
        sections = {
          recent = {
            folded = false,
          },
        },
      }
    end,
  }

  use {
    'sindrets/diffview.nvim',
    requires = 'nvim-lua/plenary.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
    setup = function()
      vim.keymap.set('n', '<LocalLeader>gd', function()
        vim.cmd('DiffviewOpen --untracked-files=no -- ' .. vim.fn.expand('%:p'))
      end)
      vim.keymap.set('n', '<LocalLeader>gD', '<Cmd>DiffviewOpen<CR>')
      vim.keymap.set('n', '<LocalLeader>gf', '<Cmd>DiffviewFileHistory<CR>')
    end,
    config = function()
      require('diffview').setup {
        enhanced_diff_hl = true,
        file_panel = {
          position = 'bottom',
          width = 35,
          height = 12,
        },
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
        hooks = {
          diff_buf_read = function()
            vim.opt_local.list = false
          end,
          view_opened = function()
            vim.cmd('wincmd p')
          end,
        },
      }
    end,
  }

  use {
    'lewis6991/gitsigns.nvim',
    requires = 'nvim-lua/plenary.nvim',
    event = 'BufRead',
    config = function()
      require('ky.config.gitsigns')
    end,
  }

  use {
    'haya14busa/vim-edgemotion',
    keys = { '<Plug>(edgemotion-' },
    setup = function()
      vim.keymap.set({ 'n', 'x' }, '<C-j>', '<Plug>(edgemotion-j)')
      vim.keymap.set({ 'n', 'x' }, '<C-k>', '<Plug>(edgemotion-k)')
    end,
  }

  use {
    'kana/vim-textobj-user',
    event = 'BufRead',
    requires = {
      { 'kana/vim-textobj-entire', after = 'vim-textobj-user' },
      { 'kana/vim-textobj-line', after = 'vim-textobj-user' },
      { 'kana/vim-textobj-indent', after = 'vim-textobj-user' },
      { 'Julian/vim-textobj-variable-segment', after = 'vim-textobj-user' },
    },
  }

  use {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make',
        after = 'telescope.nvim',
        config = function()
          require('telescope').load_extension('fzf')
        end,
      },
      {
        'ahmedkhalf/project.nvim',
        after = 'telescope.nvim',
        config = function()
          require('project_nvim').setup {}
          require('telescope').load_extension('projects')
          vim.keymap.set('n', '<LocalLeader>fp', '<Cmd>Telescope projects<CR>')
        end,
      },
      {
        'nvim-telescope/telescope-file-browser.nvim',
        after = 'telescope.nvim',
        config = function()
          require('telescope').load_extension('file_browser')

          vim.keymap.set('n', '<LocalLeader>.', function()
            require('telescope').extensions.file_browser.file_browser {
              hidden = true,
            }
          end)
          vim.keymap.set('n', '<LocalLeader>-', function()
            require('telescope').extensions.file_browser.file_browser {
              cwd = '%:p:h',
              hidden = true,
            }
          end)
          vim.keymap.set('n', '<LocalLeader>~', function()
            require('telescope').extensions.file_browser.file_browser {
              cwd = '$HOME',
              hidden = true,
            }
          end)
          vim.keymap.set('n', '<LocalLeader>+', function()
            local _cwd = vim.loop.cwd()
            local ok, util = pcall(require, 'lspconfig.util')
            local cwd = ok and util.find_git_ancestor(_cwd) or _cwd
            require('telescope').extensions.file_browser.file_browser {
              cwd = cwd,
              hidden = true,
            }
          end)
        end,
      },
      {
        'natecraddock/telescope-zf-native.nvim',
        after = 'telescope.nvim',
        config = function()
          require('telescope').load_extension('zf-native')
        end,
      },
      {
        'AckslD/nvim-neoclip.lua',
        after = 'telescope.nvim',
        config = function()
          require('neoclip').setup {
            default_register = { '"', '+' },
          }
          require('telescope').load_extension('neoclip')
          vim.keymap.set('n', '<LocalLeader>"', '<Cmd>Telescope neoclip<CR>')
        end,
      },
    },
    config = function()
      require('ky.config.telescope')
    end,
  }

  use {
    'kana/vim-submode',
    event = 'BufRead',
    config = function()
      require('ky.config.submode')
    end,
  }

  use {
    'ojroques/vim-oscyank',
    event = 'TextYankPost',
    config = function()
      vim.api.nvim_create_autocmd('TextYankPost', {
        group = vim.api.nvim_create_augroup('oscyank', { clear = true }),
        callback = function()
          if vim.v.event.operator == 'y' and vim.v.event.regname == '' then
            vim.cmd('OSCYankReg "')
          end
        end,
      })
    end,
  }

  use {
    'kevinhwang91/nvim-hclipboard',
    event = 'BufRead',
    config = function()
      require('hclipboard').start()
    end,
  }

  use {
    'norcalli/nvim-colorizer.lua',
    opt = true,
    config = function()
      require('colorizer').setup()
    end,
  }

  -- use {
  --   'mfussenegger/nvim-dap',
  --   config = function()
  --     require 'ky.config.dap'
  --   end,
  -- }

  -- use {
  --   'rcarriga/nvim-dap-ui',
  --   config = function()
  --     require('dapui').setup()
  --   end,
  -- }

  use {
    'folke/todo-comments.nvim',
    requires = 'nvim-lua/plenary.nvim',
    cmd = { 'TodoQuickFix', 'TodoTrouble', 'TodoTelescope' },
    setup = function()
      -- vim.keymap.set('n', '<LocalLeader>tf', '<Cmd>TodoTelescope<CR>')
      vim.keymap.set('n', '<LocalLeader>tq', '<Cmd>TodoQuickFix<CR>')
      vim.keymap.set('n', '<LocalLeader>tt', '<Cmd>TodoTrouble<CR>')
    end,
    config = function()
      require('todo-comments').setup {}
    end,
  }

  use {
    'rcarriga/nvim-notify',
    config = function()
      local notify = require('notify')
      -- local icons = require('ky.theme').icons
      notify.setup {
        timeout = 1500,
        -- icons = {
        --   ERROR = vim.trim(icons.error),
        --   WARN = vim.trim(icons.warn),
        --   INFO = vim.trim(icons.info),
        -- },
      }
      vim.notify = notify
    end,
  }

  use {
    'vuki656/package-info.nvim',
    requires = 'MunifTanjim/nui.nvim',
    cond = function()
      local ok, util = pcall(require, 'lspconfig.util')
      return ok and not not util.find_node_modules_ancestor(vim.loop.cwd())
    end,
    config = function()
      require('package-info').setup {}
    end,
  }

  use {
    'iamcco/markdown-preview.nvim',
    ft = { 'markdown' },
    run = function()
      if not_headless() then
        vim.fn['mkdp#util#install']()
      end
    end,
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

  use {
    'stevearc/dressing.nvim',
    event = { 'BufRead' },
  }

  use {
    'folke/persistence.nvim',
    event = 'BufReadPre', -- this will only start session saving when an actual file was opened
    module = 'persistence',
    setup = function()
      -- restore the session for the current directory
      vim.keymap.set('n', '<LocalLeader>qs', require('persistence').load)
      -- restore the last session
      vim.keymap.set('n', '<LocalLeader>ql', function()
        require('persistence').load { last = true }
      end)
      -- stop Persistence => session won't be saved on exit
      vim.keymap.set('n', '<LocalLeader>qd', require('persistence').stop)
    end,
    config = function()
      require('persistence').setup()
    end,
  }

  use {
    'andymass/vim-matchup',
    event = 'BufRead',
    setup = function()
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_deferred_hide_delay = 300
    end,
  }

  use {
    'rlane/pounce.nvim',
    setup = function()
      vim.keymap.set({ 'n', 'x', 'o' }, '<LocalLeader>s', '<Cmd>Pounce<CR>')
      vim.keymap.set({ 'n', 'x', 'o' }, '<LocalLeader>S', '<Cmd>PounceRepeat<CR>')
    end,
    config = function()
      require('pounce').setup {
        accept_keys = 'JFKDLSAHGNUVRBYTMICEOXWPQZ',
        accept_best_key = '<enter>',
        multi_window = true,
        debug = false,
      }
    end,
  }

  use {
    'tpope/vim-projectionist',
    setup = function()
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
    end,
  }

  use {
    'vim-test/vim-test',
    cmd = { 'Test*' },
    keys = {
      { 'n', '<LocalLeader>t' },
    },
    setup = function()
      vim.g['test#strategy'] = 'harpoon'
      vim.g['test#harpoon_term'] = 1

      vim.keymap.set('n', '<LocalLeader>tn', '<Cmd>TestNearest<CR>')
      vim.keymap.set('n', '<LocalLeader>tf', '<Cmd>TestFile<CR>')
      vim.keymap.set('n', '<LocalLeader>ts', '<Cmd>TestSuite<CR>')
      vim.keymap.set('n', '<LocalLeader>tv', '<Cmd>TestVisit<CR>')
    end,
  }

  use('gpanders/editorconfig.nvim')

  use {
    'ThePrimeagen/harpoon',
    config = function()
      require('ky.config.harpoon')
    end,
  }

  use {
    'alvarosevilla95/luatab.nvim',
    event = { 'BufRead' },
    config = function()
      require('luatab').setup {}
    end,
  }

  use {
    'kana/vim-smartword',
    keys = { '<Plug>(smartword-' },
    setup = function()
      for _, v in ipairs { 'w', 'b', 'e', 'ge' } do
        vim.keymap.set({ 'n', 'x', 'o' }, v, string.format('<Plug>(smartword-%s)', v))
      end
    end,
  }

  use {
    'kwkarlwang/bufjump.nvim',
    setup = function()
      vim.keymap.set('n', '<M-o>', function()
        require('bufjump').backward()
      end, { desc = 'jump to previous buffer in the jumplist' })
      vim.keymap.set('n', '<M-i>', function()
        require('bufjump').forward()
      end, { desc = 'jump to next buffer in the jumplist' })
    end,
  }

  use {
    'kosayoda/nvim-lightbulb',
    event = { 'BufRead' },
    setup = function()
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        callback = function()
          require('nvim-lightbulb').update_lightbulb()
        end,
      })
    end,
  }

  use {
    'mvllow/modes.nvim',
    disable = true,
    event = { 'BufRead' },
    config = function()
      vim.opt.cursorline = true
      require('modes').setup {
        focus_only = true,
      }
    end,
  }

  use {
    'akinsho/git-conflict.nvim',
    event = { 'BufRead' },
    config = function()
      require('git-conflict').setup()
    end,
  }

  use {
    'feline-nvim/feline.nvim',
    event = 'VimEnter',
    config = function()
      require('ky.config.feline')
    end,
  }

  use {
    'gbprod/yanky.nvim',
    keys = { '<Plug>(Yanky' },
    cmd = { 'YankyRingHistory' },
    setup = function()
      vim.keymap.set({ 'n', 'x' }, 'p', '<Plug>(YankyPutAfter)')
      vim.keymap.set({ 'n', 'x' }, 'P', '<Plug>(YankyPutBefore)')
      vim.keymap.set({ 'n', 'x' }, 'gp', '<Plug>(YankyGPutAfter)')
      vim.keymap.set({ 'n', 'x' }, 'gP', '<Plug>(YankyGPutBefore)')
      vim.keymap.set('n', ']y', '<Plug>(YankyCycleForward)')
      vim.keymap.set('n', '[y', '<Plug>(YankyCycleBackward)')
      vim.keymap.set({ 'n', 'x' }, 'y', '<Plug>(YankyYank)')
      vim.keymap.set('n', '<LocalLeader>y', '<Cmd>YankyRingHistory<CR>')
    end,
    config = function()
      require('yanky').setup()
      require('telescope').load_extension('yank_history')
    end,
  }

  use('tpope/vim-repeat')

  use {
    'AckslD/nvim-trevJ.lua',
    module = 'trevj',
    setup = function()
      vim.keymap.set('n', '<LocalLeader>j', function()
        require('trevj').format_at_cursor()
      end)
    end,
    config = function()
      require('trevj').setup()
    end,
  }

  use {
    'rainbowhxch/accelerated-jk.nvim',
    keys = { '<Plug>(accelerated_jk_' },
    setup = function()
      for _, v in ipairs { 'j', 'k' } do
        vim.keymap.set('n', v, function()
          return vim.v.count == 0 and string.format('<Plug>(accelerated_jk_g%s)', v)
            or string.format('<Plug>(accelerated_jk_%s)', v)
        end, { expr = true })
      end
    end,
  }

  use {
    'lewis6991/hover.nvim',
    disable = true,
    event = 'BufRead',
    config = function()
      require('hover').setup {
        init = function()
          -- Require providers
          require('hover.providers.lsp')
          -- require('hover.providers.gh')
          -- require('hover.providers.man')
          require('hover.providers.dictionary')
        end,
        preview_opts = {
          border = nil,
        },
        title = true,
      }

      -- Setup keymaps
      vim.keymap.set('n', 'K', require('hover').hover, { desc = 'hover.nvim' })
      vim.keymap.set('n', 'gK', require('hover').hover_select, { desc = 'hover.nvim (select)' })
    end,
  }
end

bootstrap()

vim.keymap.set('n', '<LocalLeader>pc', '<Cmd>PackerCompile<CR>')
vim.keymap.set('n', '<LocalLeader>pC', '<Cmd>PackerClean<CR>')
vim.keymap.set('n', '<LocalLeader>ps', '<Cmd>PackerSync<CR>')
vim.keymap.set('n', '<LocalLeader>pS', '<Cmd>PackerStatus<CR>')
vim.keymap.set('n', '<LocalLeader>pu', '<Cmd>PackerUpdate<CR>')
vim.keymap.set('n', '<LocalLeader>pi', '<Cmd>PackerInstall<CR>')

vim.api.nvim_create_autocmd('User', {
  pattern = 'PackerCompileDone',
  callback = function()
    vim.notify('packer.compile: Complete', vim.log.levels.INFO, { title = 'packer.nvim' })
  end,
})

require('packer').startup {
  plugins,
  config = config,
}
