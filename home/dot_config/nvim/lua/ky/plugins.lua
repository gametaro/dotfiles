if not prequire('packer') then
  print(vim.fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    '--branch',
    'main',
    'https://github.com/wbthomason/packer.nvim',
    vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim',
  }))
end

require('packer').setup({
  display = {
    prompt_border = require('ky.ui').border,
  },
})
require('packer').add({
  -- Package manager
  { 'wbthomason/packer.nvim', branch = 'main', start = true },

  -- Icon
  {
    'kyazdani42/nvim-web-devicons',
    requires = 'DaikyXendo/nvim-material-icon',
    config = function()
      require('nvim-web-devicons').setup({
        override = require('nvim-material-icon').get_icons(),
      })
    end,
  },

  -- Syntax/Highlight
  {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    start = true,
    config = function()
      require('nvim-treesitter.configs').setup({
        auto_install = true,
        ignore_install = { 'comment' },
        highlight = {
          enable = true,
          -- disable = { 'html' },
        },
        incremental_selection = {
          enable = false,
        },
        indent = {
          enable = true,
        },
        context_commentstring = {
          enable = true,
          enable_autocmd = false,
        },
        rainbow = {
          enable = true,
          disable = { 'html' },
          extended_mode = true,
          max_file_length = 1000,
        },
        matchup = {
          enable = true,
        },
        autotag = {
          enable = true,
        },
        playground = {
          enable = true,
          disable = {},
          updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
          persist_queries = false, -- Whether the query persists across vim sessions
          keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            include_surrounding_whitespace = true,
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['aC'] = '@class.outer',
              ['iC'] = '@class.inner',
              -- ['a,'] = '@parameter.outer',
              -- ['i,'] = '@parameter.inner',
              ['ac'] = '@comment.outer',
              ['ic'] = '@comment.outer',
            },
          },
          swap = {
            enable = true,
            swap_next = { ['g>'] = '@parameter.inner' },
            swap_previous = { ['g<'] = '@parameter.inner' },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']m'] = '@function.outer',
              [']]'] = '@class.outer',
              [']/'] = '@comment.outer',
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[['] = '@class.outer',
              ['[/'] = '@comment.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
          },
          lsp_interop = {
            enable = false,
            border = require('ky.ui').border,
            peek_definition_code = {
              ['df'] = '@function.outer',
            },
          },
        },
      })
    end,
  },
  'p00f/nvim-ts-rainbow',
  {
    'zbirenbaum/neodim',
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
  'norcalli/nvim-colorizer.lua',
  'mtdl9/vim-log-highlighting',
  'nvim-treesitter/playground',
  -- {
  --   'levouh/tint.nvim',
  --   config = function()
  --     require('tint').setup({
  --       highlight_ignore_patterns = {
  --         'WinSeparator',
  --         'Status.*',
  --       },
  --       window_ignore_function = function(win)
  --         local buf = vim.api.nvim_win_get_buf(win)
  --         if vim.api.nvim_win_get_config(win).relative ~= '' then
  --           return true
  --         end
  --         if vim.bo[buf].buftype == 'terminal' then
  --           return true
  --         end
  --         if
  --           vim.tbl_contains(
  --             { 'qf', 'DiffviewFiles', 'DiffviewFileHistory', 'Trouble' },
  --             vim.bo[buf].filetype
  --           )
  --         then
  --           return true
  --         end
  --         if vim.wo[win].diff then
  --           return true
  --         end
  --         return false
  --       end,
  --     })
  --   end,
  -- },
  {
    'RRethy/vim-illuminate',
    config = function()
      require('illuminate').configure({
        modes_denylist = { 'i' },
        filetypes_denylist = { 'qf' },
      })
    end,
  },
  {
    't9md/vim-quickhl',
    config_pre = function()
      vim.keymap.set({ 'n', 'x' }, '<LocalLeader>m', '<Plug>(quickhl-manual-this-whole-word)')
      vim.keymap.set({ 'n', 'x' }, '<LocalLeader>M', '<Plug>(quickhl-manual-reset)')
    end,
  },
  'itchyny/vim-highlighturl',

  -- Editing support
  {
    'gbprod/substitute.nvim',
    config = function()
      vim.keymap.set('n', '_', require('substitute').operator)
      vim.keymap.set('x', '_', require('substitute').visual)
      vim.keymap.set('n', 'X', require('substitute.exchange').operator)
      vim.keymap.set('x', 'X', require('substitute.exchange').visual)
      vim.keymap.set('n', 'Xc', require('substitute.exchange').cancel)

      require('substitute').setup({
        on_substitute = function(event)
          require('yanky').init_ring('p', event.register, event.count, event.vmode:match('[vV]'))
        end,
      })
    end,
  },
  {
    'gbprod/yanky.nvim',
    requires = 'kkharji/sqlite.lua',
    config = function()
      local mapping = require('yanky.telescope.mapping')

      require('yanky').setup({
        ring = {
          storage = 'sqlite',
        },
        picker = {
          telescope = {
            mappings = {
              default = mapping.put('p'),
              i = {
                ['<C-p>'] = nil,
                ['<C-x>'] = mapping.delete(),
              },
              n = {
                p = mapping.put('p'),
                P = mapping.put('P'),
                x = mapping.delete(),
              },
            },
          },
        },
        system_clipboard = {
          sync_with_ring = false,
        },
        highlight = {
          on_put = true,
          on_yank = false,
          timer = 200,
        },
      })
      require('telescope').load_extension('yank_history')

      vim.keymap.set({ 'n', 'x' }, 'p', '<Plug>(YankyPutAfter)')
      vim.keymap.set({ 'n', 'x' }, 'P', '<Plug>(YankyPutBefore)')
      vim.keymap.set({ 'n', 'x' }, 'gp', '<Plug>(YankyGPutAfter)')
      vim.keymap.set({ 'n', 'x' }, 'gP', '<Plug>(YankyGPutBefore)')
      vim.keymap.set('n', ']y', '<Plug>(YankyCycleForward)')
      vim.keymap.set('n', '[y', '<Plug>(YankyCycleBackward)')
      vim.keymap.set({ 'n', 'x' }, 'y', '<Plug>(YankyYank)')
      vim.keymap.set('n', '<LocalLeader>fy', function()
        require('telescope').extensions.yank_history.yank_history({})
      end)
      vim.keymap.set({ 'n', 'x' }, ']p', '<Plug>(YankyPutIndentAfterLinewise)')
      vim.keymap.set({ 'n', 'x' }, '[p', '<Plug>(YankyPutIndentBeforeLinewise)')
      vim.keymap.set({ 'n', 'x' }, ']P', '<Plug>(YankyPutIndentAfterLinewise)')
      vim.keymap.set({ 'n', 'x' }, '[P', '<Plug>(YankyPutIndentBeforeLinewise)')
      vim.keymap.set({ 'n', 'x' }, '>p', '<Plug>(YankyPutIndentAfterShiftRight)')
      vim.keymap.set({ 'n', 'x' }, '<p', '<Plug>(YankyPutIndentAfterShiftLeft)')
      vim.keymap.set({ 'n', 'x' }, '>P', '<Plug>(YankyPutIndentBeforeShiftRight)')
      vim.keymap.set({ 'n', 'x' }, '<P', '<Plug>(YankyPutIndentBeforeShiftLeft)')
      vim.keymap.set({ 'n', 'x' }, '=p', '<Plug>(YankyPutAfterFilter)')
      vim.keymap.set({ 'n', 'x' }, '=P', '<Plug>(YankyPutBeforeFilter)')
    end,
  },
  {
    'gbprod/stay-in-place.nvim',
    config = function()
      require('stay-in-place').setup({})
    end,
  },
  {
    'kana/vim-niceblock',
    config_pre = function()
      vim.g.niceblock_no_default_key_mappings = 1

      vim.keymap.set('x', 'A', '<Plug>(niceblock-A)')
      vim.keymap.set('x', 'I', '<Plug>(niceblock-I)')
    end,
  },
  'gpanders/editorconfig.nvim',
  {
    'andymass/vim-matchup',
    config_pre = function()
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_deferred_hide_delay = 300
      vim.g.matchup_matchparen_offscreen = { method = 'popup' }
    end,
  },
  {
    'monaqa/dial.nvim',
    config = function()
      local augend = require('dial.augend')

      local default = {
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.date.alias['%Y/%m/%d'],
        augend.date.alias['%Y-%m-%d'],
        augend.date.alias['%m/%d'],
        augend.date.alias['%H:%M'],
        augend.constant.alias.bool,
        augend.constant.new({
          elements = { 'TODO', 'WARN', 'NOTE', 'HACK' },
        }),
        augend.paren.new({
          patterns = { { "'", "'" }, { '"', '"' }, { '`', '`' } },
          escape_char = [[\]],
        }),
      }

      local with_default = function(group_name)
        group_name = group_name or {}
        for _, v in ipairs(default) do
          table.insert(group_name, v)
        end
        return group_name
      end

      local lua = {
        augend.paren.alias.lua_str_literal,
        augend.constant.new({
          elements = { 'and', 'or' },
        }),
        augend.constant.new({
          elements = { 'pairs', 'ipairs' },
        }),
      }

      local python = {
        augend.constant.new({
          elements = { 'True', 'False' },
        }),
      }

      local markdown = {
        augend.misc.alias.markdown_header,
      }

      local typescript = {
        augend.constant.new({
          elements = { 'let', 'const' },
        }),
        augend.constant.new({
          elements = { '&&', '||', '??' },
        }),
        augend.constant.new({
          elements = { 'console.log', 'console.warn', 'console.error' },
        }),
      }

      require('dial.config').augends:register_group({
        default = default,
        lua = with_default(lua),
        python = with_default(python),
        typescript = with_default(typescript),
        markdown = with_default(markdown),
      })

      vim.keymap.set({ 'n', 'x' }, '<C-a>', '<Plug>(dial-increment)')
      vim.keymap.set({ 'n', 'x' }, '<C-x>', '<Plug>(dial-decrement)')
      vim.keymap.set('x', 'g<C-a>', 'g<Plug>(dial-increment)')
      vim.keymap.set('x', 'g<C-x>', 'g<Plug>(dial-decrement)')

      local group = vim.api.nvim_create_augroup('DialMapping', { clear = true })
      local group_names = { 'lua', 'python', 'typescript', 'markdown' }
      for _, group_name in ipairs(group_names) do
        vim.api.nvim_create_autocmd('FileType', {
          group = group,
          pattern = group_name,
          callback = function(a)
            local function map(mode, lhs, rhs, opts)
              opts = opts or {}
              opts.buffer = a.buf
              vim.keymap.set(mode, lhs, rhs, opts)
            end

            map('n', '<C-a>', require('dial.map').inc_normal(group_name))
            map('x', '<C-a>', require('dial.map').inc_visual(group_name))
            map('n', '<C-x>', require('dial.map').dec_normal(group_name))
            map('x', '<C-x>', require('dial.map').dec_visual(group_name))
            map('x', 'g<C-a>', require('dial.map').inc_gvisual(group_name))
            map('x', 'g<C-x>', require('dial.map').dec_gvisual(group_name))
          end,
        })
      end
    end,
  },
  {
    'windwp/nvim-autopairs',
    config = function()
      local npairs = require('nvim-autopairs')
      npairs.setup({
        check_ts = true,
        enable_check_bracket_line = true,
        fast_wrap = {},
        map_c_h = true,
        map_c_w = true,
      })

      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())

      local Rule = require('nvim-autopairs.rule')
      local cond = require('nvim-autopairs.conds')

      npairs.add_rules({
        -- add spaces between parentheses
        -- https://github.com/windwp/nvim-autopairs/wiki/Custom-rules#add-spaces-between-parentheses
        Rule(' ', ' '):with_pair(function(opts)
          local pair = opts.line:sub(opts.col - 1, opts.col)
          return vim.tbl_contains({ '()', '[]', '{}' }, pair)
        end),
        Rule('( ', ' )')
          :with_pair(function()
            return false
          end)
          :with_move(function(opts)
            return opts.prev_char:match('.%)') ~= nil
          end)
          :use_key(')'),
        Rule('{ ', ' }')
          :with_pair(function()
            return false
          end)
          :with_move(function(opts)
            return opts.prev_char:match('.%}') ~= nil
          end)
          :use_key('}'),
        Rule('[ ', ' ]')
          :with_pair(function()
            return false
          end)
          :with_move(function(opts)
            return opts.prev_char:match('.%]') ~= nil
          end)
          :use_key(']'),
        Rule('=', '')
          :with_pair(cond.not_inside_quote())
          :with_pair(function(opts)
            local last_char = opts.line:sub(opts.col - 1, opts.col - 1)
            if last_char:match('[%w%=%s]') then
              return true
            end
            return false
          end)
          :replace_endpair(function(opts)
            local prev_2char = opts.line:sub(opts.col - 2, opts.col - 1)
            local next_char = opts.line:sub(opts.col, opts.col)
            next_char = next_char == ' ' and '' or ' '
            if prev_2char:match('%w$') then
              return '<bs> =' .. next_char
            end
            if prev_2char:match('%=$') then
              return next_char
            end
            if prev_2char:match('=') then
              return '<bs><bs>=' .. next_char
            end
            return ''
          end)
          :set_end_pair_length(0)
          :with_move(cond.none())
          :with_del(cond.none()),
      })
    end,
  },
  {
    'ojroques/nvim-osc52',
    config = function()
      vim.keymap.set('n', '<LocalLeader>y', require('osc52').copy_operator, { expr = true })
      vim.keymap.set('x', '<LocalLeader>y', require('osc52').copy_visual)
    end,
  },
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.pairs').setup({
        modes = { insert = false, command = true, terminal = true },
      })

      vim.keymap.set(
        { 'c', 't' },
        '<C-h>',
        'v:lua.MiniPairs.bs()',
        { expr = true, replace_keycodes = false, desc = 'MiniPairs <BS>' }
      )

      require('mini.indentscope').setup({
        draw = {
          animation = require('mini.indentscope').gen_animation.none(),
        },
        options = {
          try_as_border = true,
        },
        symbol = '|',
      })

      local group = vim.api.nvim_create_augroup('mine__mini', {})
      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        pattern = { '', 'checkhealth', 'help', 'lspinfo', 'man', 'packer' },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
      vim.api.nvim_create_autocmd('BufEnter', {
        group = group,
        callback = function()
          if vim.tbl_contains({ 'nofile', 'quickfix', 'terminal' }, vim.bo.buftype) then
            vim.b.miniindentscope_disable = true
          end
        end,
      })

      local trailspace = require('mini.trailspace')
      trailspace.setup({})
      vim.api.nvim_create_autocmd('BufWritePost', {
        group = group,
        callback = trailspace.trim,
      })

      require('mini.comment').setup({
        hooks = {
          pre = function()
            require('ts_context_commentstring.internal').update_commentstring()
          end,
        },
      })

      require('mini.ai').setup({
        custom_textobjects = {
          -- textobj-entire
          e = function()
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line('$'),
              col = math.max(vim.fn.getline('$'):len(), 1),
            }
            return { from = from, to = to }
          end,
          -- textobj-line (i only)
          l = function()
            if vim.api.nvim_get_current_line() == '' then
              return
            end
            vim.cmd.normal({ '^', bang = true })
            local from_line, from_col = unpack(vim.api.nvim_win_get_cursor(0))
            local from = { line = from_line, col = from_col + 1 }
            vim.cmd.normal({ 'g_', bang = true })
            local to_line, to_col = unpack(vim.api.nvim_win_get_cursor(0))
            local to = { line = to_line, col = to_col + 1 }
            return { from = from, to = to }
          end,
          d = function()
            return vim.tbl_map(function(diagnostic)
              local from_line = diagnostic.lnum + 1
              local from_col = diagnostic.col + 1
              local to_line = diagnostic.end_lnum + 1
              local to_col = diagnostic.end_col + 1
              return {
                from = { line = from_line, col = from_col },
                to = { line = to_line, col = to_col },
              }
            end, vim.diagnostic.get(0))
          end,
        },
        mappings = {
          around_last = '',
          inside_last = '',
        },
      })

      local map = require('mini.map')
      map.setup({
        integrations = {
          map.gen_integration.builtin_search(),
          map.gen_integration.gitsigns(),
          map.gen_integration.diagnostic({
            error = 'DiagnosticFloatingError',
            warn = 'DiagnosticFloatingWarn',
            info = 'DiagnosticFloatingInfo',
            hint = 'DiagnosticFloatingHint',
          }),
        },
        symbols = {
          encode = map.gen_encode_symbols.dot('4x2'),
          scroll_line = '█',
          scroll_view = '▒',
        },
        window = {
          focusable = true,
          show_integration_count = false,
          winblend = 50,
        },
      })
      vim.keymap.set('n', '<LocalLeader>mc', map.close)
      vim.keymap.set('n', '<LocalLeader>mf', map.toggle_focus)
      vim.keymap.set('n', '<LocalLeader>mo', map.open)
      vim.keymap.set('n', '<LocalLeader>mr', map.refresh)
      vim.keymap.set('n', '<LocalLeader>ms', map.toggle_side)
      vim.keymap.set('n', '<LocalLeader>mt', map.toggle)

      vim.api.nvim_create_autocmd('User', {
        pattern = 'SessionLoadPost',
        group = group,
        callback = map.open,
      })

      vim.keymap.set('n', '<LocalLeader>z', require('mini.misc').zoom)
    end,
  },
  'tpope/vim-repeat',
  'windwp/nvim-ts-autotag',
  {
    'johmsalas/text-case.nvim',
    config = function()
      require('textcase').setup()
    end,
  },
  {
    'Wansmer/treesj',
    config = function()
      require('treesj').setup({
        use_default_keymaps = false,
      })
      vim.keymap.set('n', '<LocalLeader>j', vim.cmd.TSJToggle)
    end,
  },
  {
    'kylechui/nvim-surround',
    config = function()
      require('nvim-surround').setup({
        move_cursor = false,
      })
    end,
  },
  {
    'smjonas/live-command.nvim',
    config = function()
      require('live-command').setup({
        commands = {
          Norm = { cmd = 'norm' },
        },
      })
    end,
  },
  {
    'axelvc/template-string.nvim',
    config = function()
      require('template-string').setup()
    end,
  },
  {
    'cshuaimin/ssr.nvim',
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

  {
    'neovim/nvim-lspconfig',
    requires = {
      'jose-elias-alvarez/typescript.nvim',
      'b0o/schemastore.nvim',
      'lukas-reineke/lsp-format.nvim',
      'folke/neodev.nvim',
    },
    config = function()
      local lspconfig = require('lspconfig')
      local cmp_nvim_lsp = require('cmp_nvim_lsp')
      local lsp_format = require('lsp-format')
      local schemastore = require('schemastore')

      local lsp = vim.lsp

      require('neodev').setup()

      local capabilities = cmp_nvim_lsp.default_capabilities()

      ---@param client table
      ---@param bufnr integer
      local on_attach = function(client, bufnr)
        ---@param mode string|string[]
        ---@param lhs string
        ---@param rhs function
        ---@param opts? table
        local function map(mode, lhs, rhs, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, lhs, rhs, opts)
        end

        -- See `:help lsp.*` for documentation on any of the below functions
        map('n', 'gD', lsp.buf.declaration)
        map('n', 'gd', lsp.buf.definition)
        map('n', 'K', lsp.buf.hover)
        map('n', 'gI', lsp.buf.implementation)
        map('i', '<C-s>', lsp.buf.signature_help)
        map('n', '<LocalLeader>wa', lsp.buf.add_workspace_folder)
        map('n', '<LocalLeader>wr', lsp.buf.remove_workspace_folder)
        map('n', '<LocalLeader>wl', function()
          vim.pretty_print(lsp.buf.list_workspace_folders())
        end)
        map('n', '<LocalLeader>D', lsp.buf.type_definition)
        map('n', '<LocalLeader>rN', lsp.buf.rename)
        map('n', '<LocalLeader>rn', function()
          return ':IncRename ' .. vim.fn.expand('<cword>')
        end, { expr = true })
        map({ 'n', 'x' }, '<LocalLeader>ca', function()
          lsp.buf.code_action({
            apply = true,
          })
        end)
        map('n', 'gr', lsp.buf.references)
        map('n', '<LocalLeader>cl', lsp.codelens.run)

        if client.config.flags then
          client.config.flags.allow_incremental_sync = true
        end

        vim.api.nvim_create_autocmd('CursorHold', {
          buffer = bufnr,
          callback = function()
            local opts = {
              focusable = false,
              close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
              border = require('ky.ui').border,
              scope = 'cursor',
            }
            vim.diagnostic.open_float(nil, opts)
          end,
        })

        map({ 'n', 'x' }, '<M-f>', function()
          lsp.buf.format({
            async = true,
            bufnr = bufnr,
            filter = function(c)
              return not vim.tbl_contains({ 'sumneko_lua' }, c.name)
            end,
          })
        end)
      end

      ---@type table<string, function>
      local custom_on_attach = {
        eslint = function(client)
          client.server_capabilities.documentFormattingProvider = true
          client.config.settings.format.enable = true
        end,
      }

      vim.api.nvim_create_autocmd('LspAttach', {
        group = 'mine',
        callback = function(a)
          if not a.data.client_id then
            return
          end

          local client = lsp.get_client_by_id(a.data.client_id)
          on_attach(client, a.buf)
          lsp_format.on_attach(client)

          if custom_on_attach[client.name] then
            custom_on_attach[client.name](client)
          end
        end,
      })

      ---@type table<string, table>
      local configs = {
        angularls = {},
        bashls = {},
        cssls = {},
        dockerls = {},
        eslint = {
          settings = {
            format = { enable = true },
          },
        },
        html = {},
        jsonls = {
          settings = {
            json = {
              schemas = schemastore.json.schemas(),
              validate = { enable = true },
            },
          },
        },
        marksman = {},
        pylsp = {},
        yamlls = {
          settings = {
            yaml = {
              schemas = schemastore.json.schemas(),
              -- for cloudformation
              -- see https://github.com/aws-cloudformation/cfn-lint-visual-studio-code/issues/69
              customTags = {
                '!And',
                '!And sequence',
                '!If',
                '!If sequence',
                '!Not',
                '!Not sequence',
                '!Equals',
                '!Equals sequence',
                '!Or',
                '!Or sequence',
                '!FindInMap',
                '!FindInMap sequence',
                '!Base64',
                '!Join',
                '!Join sequence',
                '!Cidr',
                '!Ref',
                '!Sub',
                '!Sub sequence',
                '!GetAtt',
                '!GetAZs',
                '!ImportValue',
                '!ImportValue sequence',
                '!Select',
                '!Select sequence',
                '!Split',
                '!Split sequence',
              },
            },
          },
        },
        sumneko_lua = {
          settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT',
              },
              diagnostics = {
                globals = { 'vim' },
                disable = {
                  'missing-parameter',
                  'redundant-parameter',
                },
              },
              workspace = {
                library = {
                  vim.fn.expand('$VIMRUNTIME/lua'),
                  string.format(
                    '%s/site/pack/jetpack/src/github.com/ii14/emmylua-nvim',
                    vim.fn.stdpath('data')
                  ),
                },
                -- preloadFileSize = 1000,
              },
              completion = {
                callSnippet = 'Replace',
              },
              format = {
                enable = false,
              },
            },
          },
        },
      }

      for server, config in pairs(configs) do
        config.capabilities = capabilities
        lspconfig[server].setup(config)
      end

      require('typescript').setup({
        server = {
          on_attach = on_attach,
          capabilities = capabilities,
        },
      })
    end,
  },
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup({
        ui = {
          border = require('ky.ui').border,
        },
      })
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require('mason-lspconfig').setup({
        automatic_installation = true,
      })
    end,
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
      local null_ls = require('null-ls')
      local f = null_ls.builtins.formatting
      local d = null_ls.builtins.diagnostics
      -- local h = null_ls.builtins.hover
      local ca = null_ls.builtins.code_actions

      local function executable(cmd)
        return function()
          return vim.fn.executable(cmd) == 1
        end
      end

      local sources = {
        f.prettierd.with({
          condition = executable('prettierd'),
          filetypes = { 'html', 'yaml', 'markdown', 'javascript', 'typescript' },
        }),
        f.shellharden.with({
          condition = executable('shellharden'),
        }),
        f.shfmt.with({
          condition = executable('shfmt'),
          extra_args = { '-i', '2', '-bn', '-ci', '-kp' },
        }),
        f.stylua.with({
          condition = executable('stylua'),
        }),
        f.autopep8.with({
          condition = executable('autopep8'),
        }),
        f.fish_indent.with({
          condition = executable('fish_indent'),
        }),
        f.yamlfmt.with({
          condition = executable('yamlfmt'),
        }),
        d.markdownlint.with({
          condition = executable('markdownlint'),
        }),
        d.shellcheck.with({
          condition = executable('shellcheck'),
        }),
        d.flake8.with({
          condition = executable('flake8'),
        }),
        d.pylint.with({
          condition = executable('pylint'),
        }),
        -- d.codespell.with({
        --   disabled_filetypes = { 'NeogitCommitMessage' },
        --   condition = executable('codespell'),
        --   method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
        -- }),
        d.vale.with({
          condition = executable('vale'),
        }),
        d.cfn_lint.with({
          condition = executable('cfn-lint'),
        }),
        d.zsh.with({
          condition = executable('zsh'),
        }),
        d.actionlint.with({
          condition = executable('actionlint'),
        }),
        d.gitlint.with({
          condition = executable('gitlint'),
        }),
        -- h.dictionary,
        ca.gitrebase,
        ca.shellcheck.with({
          condition = executable('shellcheck'),
        }),
        -- require('typescript.extensions.null-ls.code-actions'),
      }

      null_ls.setup({
        sources = sources,
      })
    end,
  },
  {
    'lukas-reineke/lsp-format.nvim',
    config = function()
      require('lsp-format').setup({
        typescript = {
          exclude = { 'tsserver', 'eslint' },
        },
        lua = {
          exclude = { 'sumneko_lua' },
        },
        html = {
          exclude = { 'html' },
        },
      })
    end,
  },
  {
    'smjonas/inc-rename.nvim',
    config = function()
      require('inc_rename').setup()
    end,
  },
  {
    'kosayoda/nvim-lightbulb',
    config = function()
      require('nvim-lightbulb').setup({
        autocmd = { enabled = true },
      })
    end,
  },

  -- Completion/Snippets
  {
    'hrsh7th/nvim-cmp',
    config = function()
      local cmp = require('cmp')
      local compare = require('cmp.config.compare')

      local api = vim.api

      ---@see https://github.com/lukas-reineke/cmp-under-comparator
      local compare_under_comparator = function(entry1, entry2)
        local _, entry1_under = entry1.completion_item.label:find('^_+')
        local _, entry2_under = entry2.completion_item.label:find('^_+')

        return (entry1_under or 0) < (entry2_under or 0)
      end

      local kind_icons = {
        Text = '',
        Method = '',
        Function = '',
        Constructor = '',
        Field = '',
        Variable = '',
        Class = 'ﴯ',
        Interface = '',
        Module = '',
        Property = 'ﰠ',
        Unit = '',
        Value = '',
        Enum = '',
        Keyword = '',
        Snippet = '',
        Color = '',
        File = '',
        Reference = '',
        Folder = '',
        EnumMember = '',
        Constant = '',
        Struct = '',
        Event = '',
        Operator = '',
        TypeParameter = '',
      }

      local window = {
        border = require('ky.ui').border,
        winhighlight = table.concat({
          'Normal:NormalFloat',
          'FloatBorder:FloatBorder',
          'CursorLine:PmenuSel',
          'Search:None',
        }, ','),
      }

      local config = {
        completion = {
          keyword_pattern = [[\k\+]],
        },
        confirmation = {
          default_behavior = 'replace',
        },
        window = {
          completion = cmp.config.window.bordered(window),
          documentation = cmp.config.window.bordered(window),
        },
        sorting = {
          priority_weight = 2,
          comparators = {
            compare.offset,
            compare.exact,
            -- compare.scopes,
            compare.score,
            compare.recently_used,
            compare_under_comparator,
            compare.locality,
            -- compare.kind,
            compare.sort_text,
            -- compare.length,
            compare.order,
          },
        },
        experimental = {
          ghost_text = true,
        },
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = {
          ['<C-f>'] = { i = cmp.mapping.scroll_docs(4) },
          ['<C-b>'] = { i = cmp.mapping.scroll_docs(-4) },
          ['<C-n>'] = { i = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }) },
          ['<C-p>'] = { i = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }) },
          ['<C-Space>'] = { i = cmp.mapping.complete() },
          ['<C-e>'] = { i = cmp.mapping.abort() },
          ['<CR>'] = {
            i = cmp.mapping.confirm({ select = true, behavior = cmp.SelectBehavior.Replace }),
          },
          ['<C-y>'] = {
            i = cmp.mapping.confirm({ select = true, behavior = cmp.SelectBehavior.Insert }),
          },
        },
        formatting = {
          deprecated = true,
          fields = { 'kind', 'abbr' },
          format = function(_, vim_item)
            vim_item.kind = kind_icons[vim_item.kind] or ''
            return vim_item
          end,
        },
        sources = cmp.config.sources({
          { name = 'luasnip' },
          { name = 'nvim_lsp' },
          { name = 'path' },
        }, {
          {
            name = 'buffer',
            option = {
              keyword_pattern = [[\k\+]],
              get_bufnrs = function()
                return vim.tbl_filter(function(buf)
                  local buftype = api.nvim_buf_get_option(buf, 'buftype')
                  return api.nvim_buf_is_loaded(buf)
                    and not vim.tbl_contains({
                      -- 'help',
                      'nofile',
                      'prompt',
                      'quickfix',
                      'terminal',
                    }, buftype)
                end, api.nvim_list_bufs())
              end,
            },
          },
        }),
      }

      local cmdline_mapping = cmp.mapping.preset.cmdline({
        ['<C-n>'] = {
          c = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        },
        ['<C-p>'] = {
          c = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        },
      })

      cmp.setup(config)
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmdline_mapping,
        -- view = {
        --   entries = { name = 'wildmenu', separator = '|' },
        -- },
        sources = cmp.config.sources({
          {
            name = 'buffer',
            option = {
              keyword_pattern = [[\k\+]],
              get_bufnrs = function()
                return { api.nvim_get_current_buf() }
              end,
            },
          },
        }, {
          { name = 'nvim_lsp_document_symbol' },
        }),
      })
      cmp.setup.cmdline(':', {
        mapping = cmdline_mapping,
        -- view = {
        --   entries = { name = 'wildmenu', separator = '|' },
        -- },
        sources = cmp.config.sources({
          { name = 'path' },
        }, {
          { name = 'cmdline' },
        }),
      })
      cmp.setup.filetype({ 'gitcommit', 'NeogitCommitMessage' }, {
        sources = cmp.config.sources({
          { name = 'luasnip' },
          { name = 'git' },
          { name = 'buffer' },
        }, {
          { name = 'spell' },
        }),
      })
      cmp.setup.filetype({ 'markdown' }, {
        sources = cmp.config.sources({
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'spell' },
          { name = 'emoji' },
          { name = 'buffer' },
        }),
      })
    end,
  },
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/cmp-nvim-lsp-document-symbol',
  'hrsh7th/cmp-emoji',
  'saadparwaiz1/cmp_luasnip',
  'f3fora/cmp-spell',
  {
    'petertriho/cmp-git',
    config = function()
      require('cmp_git').setup({
        filetypes = { 'gitcommit', 'NeogitCommitMessage' },
      })
    end,
  },
  {
    'L3MON4D3/LuaSnip',
    config = function()
      local ls = require('luasnip')
      local types = require('luasnip.util.types')

      local function ins_generate(nodes)
        return setmetatable(nodes or {}, {
          __index = function(table, key)
            local idx = tonumber(key)
            if idx then
              local val = ls.i(idx)
              rawset(table, key, val)
              return val
            end
          end,
        })
      end

      local function rep_generate(nodes)
        return setmetatable(nodes or {}, {
          __index = function(table, key)
            local idx = tonumber(key)
            if idx then
              local val = ls.r(idx, key)
              rawset(table, key, val)
              return val
            end
          end,
        })
      end

      ls.config.setup({
        history = true,
        update_events = 'InsertLeave',
        region_check_events = 'CursorHold',
        delete_check_events = 'TextChanged,InsertEnter',
        enable_autosnippets = true,
        store_selection_keys = '<Tab>',
        ext_opts = {
          -- [types.insertNode] = {
          --   active = {
          --     virt_text = { { '●' } },
          --   },
          -- },
          [types.choiceNode] = {
            active = {
              virt_text = { { '■' } },
            },
          },
        },
        snip_env = {
          ls = ls,
          s = require('luasnip.nodes.snippet').S,
          sn = require('luasnip.nodes.snippet').SN,
          t = require('luasnip.nodes.textNode').T,
          f = require('luasnip.nodes.functionNode').F,
          i = require('luasnip.nodes.insertNode').I,
          c = require('luasnip.nodes.choiceNode').C,
          d = require('luasnip.nodes.dynamicNode').D,
          r = require('luasnip.nodes.restoreNode').R,
          l = require('luasnip.extras').lambda,
          rep = require('luasnip.extras').rep,
          p = require('luasnip.extras').partial,
          m = require('luasnip.extras').match,
          n = require('luasnip.extras').nonempty,
          dl = require('luasnip.extras').dynamic_lambda,
          fmt = require('luasnip.extras.fmt').fmt,
          fmta = require('luasnip.extras.fmt').fmta,
          conds = require('luasnip.extras.expand_conditions'),
          types = require('luasnip.util.types'),
          events = require('luasnip.util.events'),
          parse = require('luasnip.util.parser').parse_snippet,
          ai = require('luasnip.nodes.absolute_indexer'),
          ins_generate = ins_generate,
          rep_generate = rep_generate,
        },
      })

      vim.api.nvim_create_user_command('LuaSnipEdit', function()
        require('luasnip.loaders.from_lua').edit_snippet_files()
      end, { nargs = 0 })

      vim.keymap.set({ 'i', 's' }, '<C-j>', function()
        if ls.expand_or_locally_jumpable() then
          ls.expand_or_jump()
        end
      end)
      vim.keymap.set({ 'i', 's' }, '<C-k>', function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end)
      vim.keymap.set({ 'i', 's' }, '<C-l>', function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end)

      require('luasnip.loaders.from_lua').lazy_load()
    end,
  },
  'rafamadriz/friendly-snippets',
  {
    'danymat/neogen',
    config = function()
      local neogen = require('neogen')
      neogen.setup({ snippet_engine = 'luasnip' })
      vim.keymap.set('n', '<LocalLeader>nf', function()
        neogen.generate()
      end)
      vim.keymap.set('n', '<LocalLeader>nt', function()
        neogen.generate({ type = 'type' })
      end)
      vim.keymap.set('n', '<LocalLeader>nc', function()
        neogen.generate({ type = 'class' })
      end)
      vim.keymap.set('n', '<LocalLeader>nF', function()
        neogen.generate({ type = 'file' })
      end)
    end,
  },

  -- Statusline
  {
    'rebelot/heirline.nvim',
    config = function()
      local heirline = require('heirline')
      local conditions = require('heirline.conditions')
      local utils = require('heirline.utils')
      local job = require('ky.job')
      local icons = require('ky.ui').icons

      local api = vim.api
      local cmd = vim.cmd
      local fn = vim.fn
      local diagnostic = vim.diagnostic

      local colors = {
        git = {
          add = utils.get_highlight('GitSignsAdd').fg,
          changed = utils.get_highlight('GitSignsChange').fg,
          removed = utils.get_highlight('GitSignsDelete').fg,
        },
        diff = {
          add = utils.get_highlight('DiffAdd').fg,
          change = utils.get_highlight('DiffChange').fg,
          delete = utils.get_highlight('DiffDelete').fg,
        },
        diag = {
          error = utils.get_highlight('DiagnosticError').fg,
          warn = utils.get_highlight('DiagnosticWarn').fg,
          info = utils.get_highlight('DiagnosticInfo').fg,
          hint = utils.get_highlight('DiagnosticHint').fg,
        },
        cyan = utils.get_highlight('Title').fg,
        green = utils.get_highlight('DiagnosticInfo').fg,
        magenta = utils.get_highlight('DiagnosticHint').fg,
        orange = utils.get_highlight('DiagnosticWarn').fg,
        red = utils.get_highlight('DiagnosticError').fg,
        gray = utils.get_highlight('NonText').fg,
      }

      local Align = { provider = '%=' }
      local Space = { provider = ' ' }

      local git_rev = function()
        job(
          'git',
          {
            'rev-list',
            '--count',
            '--left-right',
            'HEAD...@{upstream}',
          },
          vim.schedule_wrap(function(data)
            local ahead, behind = unpack(vim.split(data or '', '\t'))
            api.nvim_set_var('git_rev', {
              ahead = tonumber(ahead) or 0,
              behind = tonumber(behind) or 0,
            })
          end)
        )
      end

      api.nvim_create_autocmd('VimEnter', {
        group = api.nvim_create_augroup('GitRev', { clear = true }),
        once = true,
        callback = function()
          local timer = vim.loop.new_timer()
          timer:start(0, 10000, function()
            git_rev()
          end)
        end,
      })

      api.nvim_create_autocmd('User', {
        pattern = 'HeirlineInitWinbar',
        callback = function(a)
          local buf = a.buf
          local buftype = vim.tbl_contains({ 'prompt', 'nofile' }, vim.bo[buf].buftype)
          local filetype = vim.tbl_contains({ 'gitcommit' }, vim.bo[buf].filetype)

          if (buftype or filetype) and vim.bo[buf].filetype ~= 'lir' then
            vim.opt_local.winbar = nil
          end
        end,
      })

      local ViMode = {
        init = function(self)
          self.mode = api.nvim_get_mode().mode
          if not self.once then
            api.nvim_create_autocmd('ModeChanged', {
              pattern = '*:*o',
              command = 'redrawstatus',
            })
            self.once = true
          end
        end,
        static = {
          mode_names = {
            n = 'N',
            no = 'N?',
            nov = 'N?',
            noV = 'N?',
            ['no\22'] = 'N?',
            niI = 'Ni',
            niR = 'Nr',
            niV = 'Nv',
            nt = 'Nt',
            v = 'V',
            vs = 'Vs',
            V = 'V_',
            Vs = 'Vs',
            ['\22'] = '^V',
            ['\22s'] = '^V',
            s = 'S',
            S = 'S_',
            ['\19'] = '^S',
            i = 'I',
            ic = 'Ic',
            ix = 'Ix',
            R = 'R',
            Rc = 'Rc',
            Rx = 'Rx',
            Rv = 'Rv',
            Rvc = 'Rv',
            Rvx = 'Rv',
            c = 'C',
            cv = 'Ex',
            r = '...',
            rm = 'M',
            ['r?'] = '?',
            ['!'] = '!',
            t = 'T',
          },
          mode_colors = {
            n = colors.green,
            i = colors.red,
            v = colors.cyan,
            V = colors.cyan,
            ['\22'] = colors.cyan,
            c = colors.orange,
            s = colors.magenta,
            S = colors.magenta,
            ['\19'] = colors.magenta,
            R = colors.orange,
            r = colors.orange,
            ['!'] = colors.red,
            t = colors.red,
          },
        },
        update = 'ModeChanged',
        provider = function(self)
          return '%2(' .. self.mode_names[self.mode] .. '%)'
        end,
        hl = function(self)
          local mode = self.mode:sub(1, 1)
          return {
            fg = self.mode_colors[mode],
            bold = true,
          }
        end,
      }

      local FileNameBlock = {
        init = function(self)
          self.filename = api.nvim_buf_get_name(0)
        end,
        on_click = {
          name = 'heirline_filename',
          callback = function(self)
            cmd.edit(vim.fs.dirname(self.filename))
          end,
        },
      }

      local FileIcon = {
        init = function(self)
          local filename = vim.fs.basename(self.filename)
          local extension = fn.fnamemodify(filename, ':e')
          self.icon, self.icon_color =
            require('nvim-web-devicons').get_icon_color(filename, extension, { default = true })
        end,
        provider = function(self)
          return self.icon and (self.icon .. ' ')
        end,
        hl = function(self)
          return { fg = self.icon_color }
        end,
      }

      local FileName = {
        provider = function(self)
          local filename = vim.fs.basename(self.filename)
          return filename == '' and '[No Name]' or filename
        end,
        hl = { bold = false },
      }

      local FilePath = {
        provider = function(self)
          local filepath = fn.fnamemodify(self.filename, ':.:h')
          if not filepath then
            return
          end
          local trail = filepath:sub(-1) == '/' and '' or '/'
          if not conditions.width_percent_below(#filepath, 0.5) then
            filepath = fn.pathshorten(filepath)
          end
          return filepath .. trail
        end,
        hl = { fg = utils.get_highlight('Comment').fg },
      }

      local FileFlags = {
        {
          condition = function()
            return not vim.bo.modified and not vim.bo.readonly
          end,
          -- a small performance improvement:
          -- re register the component callback only on layout/buffer changes.
          update = { 'WinNew', 'WinClosed', 'BufEnter' },
          { provider = ' ' },
          {
            provider = '',
            hl = { fg = 'gray' },
            on_click = {
              callback = function(_, winid)
                pcall(api.nvim_win_close, winid, true)
              end,
              name = function(self)
                return 'heirline_close_button_' .. self.winnr
              end,
              update = true,
            },
          },
        },
        {
          condition = function()
            return vim.bo.modified
          end,
          provider = function()
            return ' ●' -- '
          end,
          hl = { fg = colors.diff.change },
        },
        {
          condition = function()
            return not vim.bo.modifiable or vim.bo.readonly
          end,
          provider = function()
            return ' '
          end,
          hl = { fg = colors.diag.warn },
        },
      }

      FileNameBlock = utils.insert(FileNameBlock, FileIcon, FileName, FileFlags, Space, FilePath)

      local FileType = {
        provider = function()
          return vim.bo.filetype
        end,
        hl = { fg = utils.get_highlight('Comment').fg },
      }

      local FileEncoding = {
        provider = function()
          local encoding = (vim.bo.fileencoding ~= '' and vim.bo.fileencoding) or vim.o.encoding
          return string.upper(encoding)
        end,
        hl = { fg = utils.get_highlight('Comment').fg },
      }

      local FileFormat = {
        init = function(self)
          self.fileformat = vim.bo.fileformat
        end,
        static = {
          fileformat_icon = {
            unix = '',
            mac = '',
            windows = '',
          },
        },
        provider = function(self)
          return self.fileformat_icon[self.fileformat]
        end,
        hl = { fg = utils.get_highlight('Comment').fg },
      }

      -- local FileSize = {
      --   provider = function()
      --     local suffix = { 'b', 'k', 'M', 'G', 'T', 'P', 'E' }
      --     local stat = vim.loop.fs_stat(api.nvim_buf_get_name(0))
      --     local fsize = stat and stat.size or 0
      --     if fsize <= 0 then
      --       return '0' .. suffix[1]
      --     end
      --     local i = math.floor((math.log(fsize) / math.log(1024)))
      --     return string.format('%.3g%s', fsize / math.pow(1024, i), suffix[i + 1])
      --   end,
      --   hl = { fg = utils.get_highlight('Comment').fg },
      -- }

      -- local FileLastModified = {
      --   provider = function()
      --     local ftime = fn.getftime(api.nvim_buf_get_name(0))
      --     return (ftime > 0) and os.date('%c', ftime)
      --   end,
      -- }

      local Ruler = {
        {
          provider = function()
            return '%3l'
          end,
        },
        {
          provider = function()
            return '/%3L:'
          end,
          hl = { fg = utils.get_highlight('Comment').fg },
        },
        {
          provider = function()
            return '%3c'
          end,
        },
      }

      local LSPActive = {
        condition = conditions.lsp_attached,
        update = { 'LspAttach', 'LspDetach' },
        on_click = {
          name = 'heirline_lsp',
          callback = function()
            -- use vim.defer_fn() if the callback requires opening of a floating window
            vim.defer_fn(function()
              cmd.LspInfo()
            end, 100)
          end,
        },
        provider = function()
          local clients = table.concat(vim.tbl_map(function(client)
            return client and string.format('%.4s…', client.name) or ''
          end, vim.lsp.get_active_clients({ bufnr = 0 })) or {}, ' ')
          if not conditions.width_percent_below(#clients, 0.25) then
            return
          end
          return clients
        end,
        hl = { fg = utils.get_highlight('Comment').fg },
      }

      local Diagnostics = {
        condition = conditions.has_diagnostics,
        init = function(self)
          self.errors = #diagnostic.get(0, { severity = diagnostic.severity.ERROR })
          self.warnings = #diagnostic.get(0, { severity = diagnostic.severity.WARN })
          self.hints = #diagnostic.get(0, { severity = diagnostic.severity.HINT })
          self.info = #diagnostic.get(0, { severity = diagnostic.severity.INFO })
        end,
        static = {
          error_icon = string.format('%s ', icons.diagnostic.error),
          warn_icon = string.format('%s ', icons.diagnostic.warn),
          info_icon = string.format('%s ', icons.diagnostic.info),
          hint_icon = string.format('%s ', icons.diagnostic.hint),
        },
        update = function()
          return api.nvim_get_mode().mode:sub(1, 1) ~= 'i'
        end,
        -- update = { 'DiagnosticChanged', 'BufEnter' },
        on_click = {
          name = 'heirline_diagnostics',
          callback = function()
            local qf = fn.getqflist({ winid = 0, title = 0 })
            if not qf then
              return
            end

            if qf.winid ~= 0 and qf.title == 'Diagnostics' then
              cmd.cclose()
            else
              diagnostic.setqflist()
            end
          end,
        },
        {
          provider = function(self)
            return self.errors > 0 and self.error_icon .. self.errors .. ' '
          end,
          hl = { fg = colors.diag.error },
        },
        {
          provider = function(self)
            return self.warnings > 0 and self.warn_icon .. self.warnings .. ' '
          end,
          hl = { fg = colors.diag.warn },
        },
        {
          provider = function(self)
            return self.info > 0 and self.info_icon .. self.info .. ' '
          end,
          hl = { fg = colors.diag.info },
        },
        {
          provider = function(self)
            return self.hints > 0 and self.hint_icon .. self.hints
          end,
          hl = { fg = colors.diag.hint },
        },
      }

      local Git = {
        condition = conditions.is_git_repo,
        {
          provider = function()
            return icons.git.branch .. ' ' .. vim.b.gitsigns_status_dict.head
          end,
          hl = { fg = colors.magenta },
        },
        {
          condition = function()
            return pcall(api.nvim_get_var, 'git_rev')
          end,
          provider = function()
            return (vim.g.git_rev.ahead > 0 and ' ' .. icons.git.ahead .. vim.g.git_rev.ahead or '')
              .. (
                vim.g.git_rev.behind > 0 and ' ' .. icons.git.behind .. vim.g.git_rev.behind or ''
              )
          end,
          hl = { fg = colors.orange },
        },
        on_click = {
          name = 'heirline_Neogit',
          callback = function()
            cmd.Neogit()
          end,
        },
      }

      local GitStatus = {
        condition = conditions.is_git_repo,
        init = function(self)
          self.status_dict = vim.b.gitsigns_status_dict
          self.has_changes = self.status_dict.added ~= 0
            or self.status_dict.removed ~= 0
            or self.status_dict.changed ~= 0
        end,
        on_click = {
          name = 'heirline_gitstatus',
          callback = function()
            local qf = fn.getqflist({ winid = 0, title = 0 })
            if not qf then
              return
            end

            if qf.winid ~= 0 and qf.title == 'Hunks' then
              cmd.cclose()
            else
              require('gitsigns').setqflist()
            end
          end,
        },
        {
          provider = function(self)
            local count = self.status_dict.added or 0
            return count > 0 and ' ' .. icons.git.add .. ' ' .. count
          end,
          hl = { fg = colors.git.add },
        },
        {
          provider = function(self)
            local count = self.status_dict.removed or 0
            return count > 0 and ' ' .. icons.git.remove .. ' ' .. count
          end,
          hl = { fg = colors.git.removed },
        },
        {
          provider = function(self)
            local count = self.status_dict.changed or 0
            return count > 0 and ' ' .. icons.git.change .. ' ' .. count
          end,
          hl = { fg = colors.git.changed },
        },
      }

      local WorkDir = {
        on_click = {
          name = 'heirline_workdir',
          callback = function()
            vim.defer_fn(function()
              cmd.edit('.')
            end, 100)
          end,
        },
        provider = function()
          local flag = (fn.haslocaldir() == 1 and 'L' or fn.haslocaldir(-1, 0) == 1 and 'T' or 'G')
          local icon = ''
          local cwd = fn.fnamemodify(vim.loop.cwd(), ':~')
          if not conditions.width_percent_below(#cwd, 0.25) then
            cwd = fn.pathshorten(cwd)
          end
          local trail = cwd:sub(-1) == '/' and '' or '/'
          return flag .. ' ' .. icon .. ' ' .. cwd .. trail
        end,
        hl = { fg = utils.get_highlight('Directory').fg },
      }

      local TerminalName = {
        init = function(self)
          self.icon, self.icon_color =
            require('nvim-web-devicons').get_icon_color_by_filetype('terminal', { default = true })
          self.tname = api.nvim_buf_get_name(0):gsub('.*:', '')
        end,
        provider = function(self)
          return self.icon .. ' ' .. self.tname
        end,
        hl = function(self)
          return { fg = self.icon_color }
        end,
      }

      local TerminalTitle = {
        provider = function()
          return vim.b.term_title
        end,
        hl = {
          fg = utils.get_highlight('Directory').fg,
          -- bold = true,
        },
      }

      local QuickfixName = {
        condition = function()
          return vim.bo.filetype == 'qf'
        end,
        init = function(self)
          self.qflist = fn.getqflist({ winid = 0, title = 0, size = 0, nr = 0, idx = 0 })
          self.loclist = fn.getloclist(0, { winid = 0, title = 0, size = 0, nr = 0, idx = 0 })
          self.qf_open = self.qflist.winid ~= 0
          self.loc_open = self.loclist.winid ~= 0
        end,
        Space,
        {
          provider = function(self)
            return self.qf_open and 'Q' or self.loc_open and 'L' or ''
          end,
          hl = { fg = colors.gray },
        },
        Space,
        {
          provider = function(self)
            return self.qf_open and self.qflist.title or self.loc_open and self.loclist.title or ''
          end,
          hl = { fg = colors.green },
        },
        Space,
        {
          provider = function(self)
            local idx = self.qf_open and self.qflist.idx or self.loc_open and self.loclist.idx or ''
            local size = self.qf_open and self.qflist.size
              or self.loc_open and self.loclist.size
              or ''
            return string.format('[%s / %s]', idx, size)
          end,
          hl = { fg = colors.gray },
        },
        Space,
        {
          provider = function(self)
            local nr = self.qf_open and self.qflist.nr or self.loc_open and self.loclist.nr or ''
            local nrs = self.qf_open and fn.getqflist({ nr = '$' }).nr
              or self.loc_open and fn.getloclist(0, { nr = '$' }).nr
              or ''
            return string.format('(%s of %s)', nr, nrs)
          end,
          hl = { fg = colors.gray },
        },
      }

      local HelpFileName = {
        condition = function()
          return vim.bo.filetype == 'help'
        end,
        provider = function()
          return ' ' .. vim.fs.basename(api.nvim_buf_get_name(0))
        end,
      }

      local LirName = {
        condition = function()
          return vim.bo.filetype == 'lir'
        end,
        init = function(self)
          local dir = require('lir').get_context().dir
          self.dir = fn.fnamemodify(dir, ':~:h')
          self.icon, self.icon_color =
            require('nvim-web-devicons').get_icon_color('lir_folder_icon')
          self.show_hidden_files = require('lir.config').values.show_hidden_files
        end,
        Align,
        {
          provider = function(self)
            return self.icon
          end,
          hl = function(self)
            return { fg = self.icon_color }
          end,
        },
        Space,
        {
          provider = function(self)
            return self.dir
          end,
          hl = function()
            return { fg = utils.get_highlight('Comment').fg }
          end,
        },
        Space,
        {
          provider = function(self)
            return self.show_hidden_files and ' ' or ' '
          end,
          hl = function(self)
            return { fg = self.show_hidden_files and colors.diag.warn or colors.gray }
          end,
        },
        Align,
      }

      local Spell = {
        condition = function()
          return vim.wo.spell
        end,
        provider = '暈',
      }

      local Snippets = {
        condition = function()
          local has_luasnip = prequire('luasnip')
          return vim.tbl_contains({ 's', 'i' }, api.nvim_get_mode().mode) and has_luasnip
        end,
        provider = function()
          local forward = (require('luasnip').expand_or_locally_jumpable()) and '' or ''
          local backward = (require('luasnip').jumpable(-1)) and ' ' or ''
          return backward .. forward
        end,
        hl = { fg = colors.orange },
      }

      local WinBars = {
        fallthrough = false,
        LirName,
        {
          condition = function()
            return conditions.buffer_matches({
              buftype = { 'nofile', 'prompt' },
              filetype = { '^git.*' },
            })
          end,
          init = function()
            vim.opt_local.winbar = nil
          end,
        },
        QuickfixName,
        HelpFileName,
        {
          condition = function()
            return conditions.buffer_matches({ buftype = { 'terminal' } })
          end,
          {
            Space,
            TerminalName,
          },
        },
        {
          Space,
          FileNameBlock,
          Align,
          Diagnostics,
          Space,
          GitStatus,
          Space,
        },
        hl = function()
          return {
            bg = conditions.is_active() and utils.get_highlight('WinBar').bg
              or utils.get_highlight('WinBarNC').bg,
          }
        end,
      }

      local Tabpage = {
        provider = function(self)
          local cwd = fn.pathshorten(fn.getcwd(-1, self.tabnr))
          return '%' .. self.tabnr .. 'T' .. '來 ' .. cwd .. ' '
        end,
        hl = function(self)
          return self.is_active and 'TabLineSel' or 'TabLine'
        end,
      }

      local TabPages = {
        condition = function()
          return #api.nvim_list_tabpages() >= 2
        end,
        utils.make_tablist(Tabpage),
        Align,
      }

      local TabLine = { TabPages }

      local DisableStatusLine = {
        condition = function()
          return vim.o.laststatus == 0
        end,
        provider = function()
          local winwidth = api.nvim_win_get_width(0)
          return string.rep('─', winwidth)
        end,
        hl = {
          fg = utils.get_highlight('WinSeparator').fg,
          bg = utils.get_highlight('WinSeparator').bg,
        },
      }

      local DefaultStatusLine = {
        ViMode,
        Space,
        -- FileNameBlock,
        -- Space,
        Git,
        -- Space,
        -- Diagnostics,
        Align,
        WorkDir,
        Align,
        Snippets,
        Spell,
        Space,
        LSPActive,
        Space,
        -- FileSize,
        -- Space,
        FileType,
        Space,
        FileEncoding,
        Space,
        FileFormat,
        Space,
        Ruler,
      }

      local InactiveStatusLine = {
        condition = function()
          return not conditions.is_active()
        end,
        FileNameBlock,
      }

      local SpecialStatusLine = {
        condition = function()
          return conditions.buffer_matches({
            buftype = { 'nofile', 'prompt', 'help', 'quickfix' },
            filetype = { '^git.*' },
          })
        end,
        ViMode,
        Align,
        WorkDir,
        Align,
        FileType,
        Space,
        Ruler,
      }

      local TerminalStatusLine = {
        condition = function()
          return conditions.buffer_matches({ buftype = { 'terminal' } })
        end,
        { condition = conditions.is_active, ViMode, Space },
        Align,
        TerminalTitle,
        Align,
        Ruler,
      }

      local StatusLines = {
        fallthrough = false,
        -- DisableStatusLine,
        SpecialStatusLine,
        TerminalStatusLine,
        -- InactiveStatusLine,
        DefaultStatusLine,
        hl = function()
          return {
            fg = conditions.is_active() and utils.get_highlight('StatusLine').fg
              or utils.get_highlight('StatusLineNC').fg,
            bg = conditions.is_active() and utils.get_highlight('StatusLine').bg
              or utils.get_highlight('StatusLineNC').bg,
          }
        end,
      }

      api.nvim_create_autocmd('ColorScheme', {
        group = api.nvim_create_augroup('mine__heirline', { clear = true }),
        callback = function()
          heirline.reset_highlights()
          heirline.load_colors(colors)
        end,
      })

      heirline.setup(StatusLines, WinBars, TabLine)
    end,
  },

  -- Colorschem
  'EdenEast/nightfox.nvim',
  'rebelot/kanagawa.nvim',
  'Mofiqul/vscode.nvim',
  'cocopon/iceberg.vim',
  'catppuccin/nvim',
  -- 'folke/tokyonight.nvim',

  -- Keybinding
  {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup({
        plugins = {
          marks = false,
          spelling = {
            enabled = true,
          },
        },
      })
    end,
  },
  {
    'anuvyklack/hydra.nvim',
    config = function()
      local Hydra = require('hydra')

      local cmd = vim.cmd

      Hydra({
        name = 'Side scroll',
        mode = 'n',
        body = 'z',
        heads = {
          { 'h', '5zh' },
          { 'l', '5zl', { desc = '←/→' } },
          { 'H', 'zH' },
          { 'L', 'zL', { desc = 'half screen ←/→' } },
        },
      })

      Hydra({
        name = 'Changelist',
        mode = 'n',
        config = {
          color = 'pink',
        },
        body = 'g',
        heads = {
          { ';', 'g;' },
          { ',', 'g,' },
        },
      })

      Hydra({
        name = 'Window size',
        mode = 'n',
        body = '<C-w>',
        heads = {
          { '+', '2<C-w>+' },
          { '-', '2<C-w>-', { desc = 'height +/-' } },
          { '>', '2<C-w>>' },
          { '<', '2<C-w><', { desc = 'width +/-' } },
          { '<Esc>', nil, { exit = true } },
        },
      })

      Hydra({
        name = 'Tab',
        mode = 'n',
        body = '<C-t>',
        heads = {
          {
            'e',
            function()
              cmd.tabnew({ '%' })
            end,
            { desc = 'Open a new tab page with an current buffer' },
          },
          { 'c', cmd.tabclose, { desc = 'Close current tab page' } },
          {
            'C',
            function()
              cmd.tabclose({ bang = true })
            end,
            { desc = 'Force close current tab page' },
          },
          { 'l', cmd.tabnext, { desc = 'Go to the next tab page' } },
          { 'h', cmd.tabprevious, { desc = 'Go to the previous tab page' } },
          { 'o', cmd.tabonly, { desc = 'Close all other tab pages' } },
          { '0', cmd.tabfirst, { desc = 'Go to the first tab page' } },
          { '$', cmd.tablast, { desc = 'Go to the last tab page' } },
          {
            'L',
            function()
              cmd.tabmove({ '+' })
            end,
            { desc = 'Move the tab page to the right' },
          },
          {
            'H',
            function()
              cmd.tabmove({ '-' })
            end,
            { desc = 'Move the tab page to the left' },
          },
        },
      })

      local gitsigns = require('gitsigns')

      local hint = [[
  _J_: next hunk   _s_: stage hunk        _d_: show deleted   _b_: blame line
  _K_: prev hunk   _u_: undo stage hunk   _p_: preview hunk   _B_: blame show full
  ^ ^              _S_: stage buffer      ^ ^                 _/_: show base file
  ^
  ^ ^              _<Enter>_: Neogit              _q_: exit
]]

      Hydra({
        hint = hint,
        config = {
          color = 'pink',
          invoke_on_body = true,
          hint = {
            position = 'bottom',
            border = 'rounded',
          },
          on_enter = function()
            vim.bo.modifiable = false
            gitsigns.toggle_signs(true)
            gitsigns.toggle_linehl(true)
          end,
          on_exit = function()
            gitsigns.toggle_signs(false)
            gitsigns.toggle_linehl(false)
            gitsigns.toggle_deleted(false)
            vim.cmd.echo() -- clear the echo area
          end,
        },
        mode = { 'n', 'x' },
        body = '<Leader>g',
        heads = {
          {
            'J',
            function()
              if vim.wo.diff then
                return ']c'
              end
              vim.schedule(function()
                gitsigns.next_hunk()
              end)
              return '<Ignore>'
            end,
            { expr = true },
          },
          {
            'K',
            function()
              if vim.wo.diff then
                return '[c'
              end
              vim.schedule(function()
                gitsigns.prev_hunk()
              end)
              return '<Ignore>'
            end,
            { expr = true },
          },
          { 's', ':Gitsigns stage_hunk<CR>', { silent = true } },
          { 'u', gitsigns.undo_stage_hunk },
          { 'S', gitsigns.stage_buffer },
          { 'p', gitsigns.preview_hunk },
          { 'd', gitsigns.toggle_deleted, { nowait = true } },
          { 'b', gitsigns.blame_line },
          {
            'B',
            function()
              gitsigns.blame_line({ full = true })
            end,
          },
          { '/', gitsigns.show, { exit = true } }, -- show the base of the file
          { '<Enter>', '<cmd>Neogit<CR>', { exit = true } },
          { 'q', nil, { exit = true, nowait = true } },
        },
      })
    end,
  },

  -- File explorer
  {
    'tamago324/lir.nvim',
    requires = 'tamago324/lir-git-status.nvim',
    config = function()
      local lir = require('lir')
      local config = require('lir.config')
      local actions = require('lir.actions')
      local mark_actions = require('lir.mark.actions')
      local clipboard_actions = require('lir.clipboard.actions')
      local history = require('lir.history')
      local Path = require('plenary.path')

      local cache_file = Path:new(vim.fn.stdpath('cache'), 'lir', 'history')

      local function save()
        local dir = cache_file:parent()
        if not dir:exists() then
          dir:mkdir({ parents = true })
        end
        cache_file:write(vim.mpack.encode(history.get_all()), 'w')
      end

      local function restore()
        if cache_file:exists() then
          local ok, histories = pcall(vim.mpack.decode, cache_file:read())
          if ok then
            history.replace_all(histories)
          end
        end
      end

      local function create()
        local cwd = vim.loop.cwd()
        -- temporarily change cwd for filename completion
        vim.cmd.cd({ lir.get_context().dir, mods = { noautocmd = true } })

        vim.ui.input({ prompt = 'New File: ', completion = 'file' }, function(input)
          -- restore original cwd
          vim.cmd.cd({ cwd, mods = { noautocmd = true, silent = true } })
          if not input or input == '' or input == '.' or input == '..' then
            return
          end

          local dir = lir.get_context().dir
          local file = Path:new(dir .. input)
          if file:exists() then
            vim.notify('file exists', vim.log.levels.INFO, { title = 'Lir' })
            return
          end
          if vim.endswith(file.filename, Path.path.sep) then
            Path:new(file.filename:sub(1, -2)):mkdir({ parents = true })
          else
            file:touch({
              parents = true,
            })
          end

          local filename = file.filename:gsub(dir, '')

          -- If the first character is '.' and show_hidden_files is false, set it to true
          if vim.startswith(filename, '.') and not config.values.show_hidden_files then
            config.values.show_hidden_files = true
          end

          actions.reload()

          -- Jump to a line in the parent directory of the file you created.
          local row = lir.get_context():indexof(filename:match('^[^/]+'))
          if row then
            vim.api.nvim_win_set_cursor(0, { row, 1 })
          end
        end)
      end

      local delete = function()
        local ctx = lir.get_context()
        local name = ctx:current_value()
        local path = Path:new(ctx.dir .. name)

        vim.ui.select(
          { 'Yes', 'No' },
          { prompt = string.format('Delete %s ?', name) },
          function(choice)
            if choice and choice == 'Yes' then
              path:rm({ recursive = path:is_dir() })
              local bufs = vim.tbl_filter(function(buf)
                return vim.api.nvim_buf_is_loaded(buf)
                  and vim.api.nvim_buf_get_name(buf) == path.filename
              end, vim.api.nvim_list_bufs())
              for _, buf in ipairs(bufs) do
                vim.api.nvim_buf_delete(buf, { force = true })
              end

              actions.reload()
            end
          end
        )
      end

      vim.api.nvim_create_autocmd('ExitPre', {
        group = vim.api.nvim_create_augroup('lir-persistent-history', { clear = true }),
        callback = save,
      })

      restore()

      require('lir').setup({
        -- ignore = { 'node_modules' },
        show_hidden_files = false,
        devicons_enable = true,
        mappings = {
          ['l'] = actions.edit,
          ['o'] = actions.edit,
          ['<CR>'] = actions.edit,
          ['s'] = actions.split,
          ['v'] = actions.vsplit,
          ['t'] = actions.tabedit,

          ['-'] = actions.up,
          ['h'] = actions.up,
          ['q'] = actions.quit,
          ['<Esc>'] = actions.quit,

          -- ['m'] = actions.mkdir,
          -- ['a'] = actions.newfile,
          ['a'] = create,
          ['r'] = actions.rename,
          ['@'] = function()
            local dir = lir.get_context().dir
            local cmd = vim.fn.haslocaldir() == 1 and 'lcd' or 'cd'
            vim.cmd[cmd]({ dir, mods = { silent = true } })
            vim.notify(cmd .. ': ' .. dir, vim.log.levels.INFO, { title = 'lir' })
          end,
          ['y'] = function()
            local file = lir.get_context():current_value()
            vim.fn.setreg(vim.v.register, file)
            vim.notify('yank: ' .. file, vim.log.levels.INFO, { title = 'lir' })
          end,
          ['Y'] = function()
            local ctx = lir.get_context()
            local path = ctx.dir .. ctx:current_value()
            vim.fn.setreg(vim.v.register, path)
            vim.notify('yank: ' .. path, vim.log.levels.INFO, { title = 'lir' })
          end,
          ['.'] = actions.toggle_show_hidden,
          ['d'] = delete,

          ['<Tab>'] = function()
            mark_actions.toggle_mark()
            vim.cmd.normal({ 'j', bang = true })
          end,
          ['<S-Tab>'] = function()
            mark_actions.toggle_mark()
            vim.cmd.normal({ 'k', bang = true })
          end,
          ['c'] = clipboard_actions.copy,
          ['x'] = clipboard_actions.cut,
          ['p'] = clipboard_actions.paste,
        },
        on_init = function()
          vim.keymap.set(
            'x',
            '<Tab>',
            ':<C-u>lua require"lir.mark.actions".toggle_mark("v")<CR>',
            { buffer = true }
          )
          vim.opt_local.signcolumn = 'no'
          vim.opt_local.spell = false
        end,
      })

      require('lir.git_status').setup({
        show_ignored = false,
      })
    end,
  },
  'tamago324/lir-git-status.nvim',

  -- Search
  {
    'haya14busa/vim-asterisk',
    config_pre = function()
      vim.g['asterisk#keeppos'] = 1
      vim.keymap.set('', '*', '<Plug>(asterisk-z*)')
      vim.keymap.set('', '#', '<Plug>(asterisk-z#)')
      vim.keymap.set('', 'g*', '<Plug>(asterisk-gz*)')
      vim.keymap.set('', 'g#', '<Plug>(asterisk-gz#)')
    end,
  },

  -- Git/Diff
  {
    'TimUntersberger/neogit',
    config = function()
      vim.keymap.set('n', '<LocalLeader>gg', vim.cmd.Neogit)

      local group = vim.api.nvim_create_augroup('NeogitFileType', { clear = true })

      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        pattern = 'NeogitStatus',
        callback = function()
          vim.wo.list = false
        end,
      })

      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        pattern = 'NeogitCommitMessage',
        callback = function()
          vim.opt_local.spell = true
          vim.opt_local.formatoptions:append({ 't' })
          vim.bo.textwidth = 72
        end,
      })

      require('neogit').setup({
        disable_builtin_notifications = true,
        disable_commit_confirmation = true,
        disable_hint = true,
        disable_insert_on_commit = false,
        signs = {
          section = { vim.opt.fillchars:get().foldclose, vim.opt.fillchars:get().foldopen },
          item = { vim.opt.fillchars:get().foldclose, vim.opt.fillchars:get().foldopen },
          hunk = { '', '' },
        },
        integrations = { diffview = true },
        sections = {
          recent = {
            folded = false,
          },
        },
      })
    end,
  },
  {
    'sindrets/diffview.nvim',
    config = function()
      local win_config = {
        position = 'bottom',
        width = 35,
        height = 12,
      }

      local actions = require('diffview.actions')

      require('diffview').setup({
        file_panel = {
          win_config = win_config,
        },
        file_history_panel = {
          win_config = win_config,
        },
        keymaps = {
          view = {
            ['q'] = actions.close,
            ['co'] = actions.conflict_choose('ours'),
            ['ct'] = actions.conflict_choose('theirs'),
            ['cb'] = actions.conflict_choose('base'),
            ['ca'] = actions.conflict_choose('all'),
          },
          file_panel = {
            ['q'] = actions.close,
          },
          file_history_panel = {
            ['q'] = actions.close,
          },
        },
        hooks = {
          view_opened = function()
            vim.cmd.wincmd('p')
            vim.cmd.wincmd('l')
          end,
        },
      })

      vim.keymap.set('n', '<LocalLeader>gd', vim.cmd.DiffviewOpen)
      vim.keymap.set('n', '<LocalLeader>gf', function()
        vim.cmd.DiffviewFileHistory('%')
      end)
      vim.keymap.set('n', '<LocalLeader>gF', vim.cmd.DiffviewFileHistory)
      vim.keymap.set('x', '<LocalLeader>gf', ":'<,'>DiffviewFileHistory<CR>")

      require('ky.abbrev').cabbrev('dvo', 'DiffviewOpen')
      require('ky.abbrev').cabbrev('dvf', 'DiffviewFileHistory')
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      local on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, lhs, rhs, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, lhs, rhs, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            return ']c'
          else
            vim.schedule(function()
              gs.next_hunk({ preview = true })
            end)
            return '<Ignore>'
          end
        end, { expr = true })
        map('n', '[c', function()
          if vim.wo.diff then
            return '[c'
          else
            vim.schedule(function()
              gs.prev_hunk({ preview = true })
            end)
            return '<Ignore>'
          end
        end, { expr = true })
        -- Actions
        map('n', '<LocalLeader>hs', gs.stage_hunk)
        map('n', '<LocalLeader>hr', gs.reset_hunk)
        map('x', '<LocalLeader>hs', function()
          gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)
        map('x', '<LocalLeader>hr', function()
          gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)
        map('n', '<LocalLeader>hS', gs.stage_buffer)
        map('n', '<LocalLeader>hu', gs.undo_stage_hunk)
        map('n', '<LocalLeader>hR', gs.reset_buffer)
        map('n', '<LocalLeader>hp', gs.preview_hunk)
        map('n', '<LocalLeader>hb', function()
          gs.blame_line({ full = true })
        end)
        map('n', '<LocalLeader>hd', gs.diffthis)
        map('n', '<LocalLeader>hD', function()
          gs.diffthis('~')
        end)
        map('n', '<LocalLeader>hq', gs.setqflist)
        map('n', '<LocalLeader>hQ', function()
          gs.setqflist('all')
        end)
        map('n', '<LocalLeader>hl', gs.setloclist)
        map('n', '<LocalLeader>tb', gs.toggle_current_line_blame)
        map('n', '<LocalLeader>td', gs.toggle_deleted)
        map('n', '<LocalLeader>tw', gs.toggle_word_diff)

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end

      require('gitsigns').setup({
        signs = {
          add = { show_count = false },
          change = { show_count = false },
          delete = { show_count = true },
          topdelete = { show_count = true },
          changedelete = { show_count = true },
        },
        preview_config = {
          border = require('ky.ui').border,
        },
        trouble = false,
        on_attach = on_attach,
        _extmark_signs = true,
        _threaded_diff = true,
      })
    end,
  },
  -- {
  --   'rhysd/committia.vim',
  --   config_pre = function()
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
    config_pre = function()
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
  {
    'ruifm/gitlinker.nvim',
    config = function()
      for _, v in ipairs({ 'n', 'v' }) do
        vim.keymap.set(v, 'gb', function()
          require('gitlinker').get_buf_range_url(
            v,
            { action_callback = vim.fn['openbrowser#open'] }
          )
        end)
        vim.keymap.set(v, '<LocalLeader>gy', function()
          require('gitlinker').get_buf_range_url(v)
        end)
      end
      vim.keymap.set('n', 'gB', function()
        require('gitlinker').get_repo_url({
          action_callback = vim.fn['openbrowser#open'],
        })
      end)
      vim.keymap.set('n', '<LocalLeader>gY', function()
        require('gitlinker').get_repo_url()
      end)

      require('gitlinker').setup({
        mappings = nil,
      })
    end,
  },
  {
    'akinsho/git-conflict.nvim',
    config = function()
      require('git-conflict').setup()
    end,
  },
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
  'AndrewRadev/linediff.vim',

  -- Motion
  {
    'haya14busa/vim-edgemotion',
    config_pre = function()
      vim.keymap.set({ 'n', 'x' }, '<C-j>', "m'<Plug>(edgemotion-j)")
      vim.keymap.set({ 'n', 'x' }, '<C-k>', "m'<Plug>(edgemotion-k)")
    end,
  },
  'bkad/CamelCaseMotion',
  -- { 'kana/vim-smartword', event = 'VimEnter' }
  {
    'gametaro/pounce.nvim',
    branch = 'cword',
    config_pre = function()
      vim.keymap.set({ 'n', 'x' }, 's', '')
      vim.keymap.set({ 'n', 'x' }, 's', vim.cmd.Pounce)
      vim.keymap.set({ 'n', 'x' }, '<LocalLeader>s', vim.cmd.PounceCword)
      vim.keymap.set({ 'n', 'x', 'o' }, 'S', vim.cmd.PounceRepeat)
      vim.keymap.set('o', 'gs', vim.cmd.Pounce)
    end,
  },
  {
    'hrsh7th/vim-eft',
    config_pre = function()
      for _, v in ipairs({ 'f', 'F', 't', 'T' }) do
        vim.keymap.set({ 'n', 'x', 'o' }, v, string.format('<Plug>(eft-%s-repeatable)', v))
      end
    end,
  },
  {
    'rainbowhxch/accelerated-jk.nvim',
    config_pre = function()
      for _, v in ipairs({ 'j', 'k' }) do
        vim.keymap.set('n', v, function()
          return vim.v.count == 0 and string.format('<Plug>(accelerated_jk_g%s)', v)
            or string.format('<Plug>(accelerated_jk_%s)', v)
        end, { expr = true })
      end
    end,
  },

  -- Text object
  'nvim-treesitter/nvim-treesitter-textobjects',
  {
    'mfussenegger/nvim-treehopper',
    config = function()
      vim.keymap.set('o', 'm', ':<C-u>lua require("tsht").nodes()<CR>')
      vim.keymap.set('x', 'm', ':lua require("tsht").nodes()<CR>')

      require('tsht').config.hint_keys = { 'h', 'j', 'f', 'd', 'n', 'v', 's', 'l', 'a' }
    end,
  },
  {
    'David-Kunz/treesitter-unit',
    config_pre = function()
      vim.keymap.set('x', 'iu', ':lua require"treesitter-unit".select()<CR>')
      vim.keymap.set('x', 'au', ':lua require"treesitter-unit".select(true)<CR>')
      vim.keymap.set('o', 'iu', ':<c-u>lua require"treesitter-unit".select()<CR>')
      vim.keymap.set('o', 'au', ':<c-u>lua require"treesitter-unit".select(true)<CR>')
    end,
  },

  -- Fuzzy Finder
  {
    'nvim-telescope/telescope.nvim',
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      local action_state = require('telescope.actions.state')
      local actions_layout = require('telescope.actions.layout')
      local themes = require('telescope.themes')
      local builtin = require('telescope.builtin')

      local borderchars = {
        prompt = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
        results = { '─', '│', '─', '│', '├', '┤', '┘', '└' },
        preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
      }

      local horizontal = {
        layout_strategy = 'horizontal',
        borderchars = borderchars.preview,
        preview_title = false,
      }

      local yank = function(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection == nil then
          return
        end
        actions.close(prompt_bufnr)
        vim.fn.setreg(vim.v.register, selection.value)
      end

      local defaults = {
        mappings = {
          i = {
            ['<C-j>'] = actions.cycle_history_next,
            ['<C-k>'] = actions.cycle_history_prev,
            ['<M-m>'] = actions_layout.toggle_mirror,
            ['<M-p>'] = actions_layout.toggle_preview,
            ['<C-s>'] = actions.select_horizontal,
            ['<C-x>'] = false,
            -- ['<C-f>'] = actions.preview_scrolling_down,
            -- ['<C-b>'] = actions.preview_scrolling_up,
            -- ['<C-u>'] = { '<C-u>', type = 'command' },
            ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
            ['<C-l>'] = actions.smart_send_to_loclist + actions.open_loclist,
            ['<C-y>'] = yank,
          },
          n = {
            ['<C-s>'] = actions.select_horizontal,
            ['<C-x>'] = false,
            ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
            ['<C-l>'] = actions.smart_send_to_loclist + actions.open_loclist,
            ['y'] = yank,
          },
        },
        path_display = { truncate = 3 },
        -- prompt_prefix = ' ',
        selection_caret = '  ',
        dynamic_preview_title = true,
        results_title = false,
        sorting_strategy = 'ascending',
        layout_strategy = 'bottom_pane',
        layout_config = {
          bottom_pane = {
            height = 0.4,
            preview_width = 0.55,
            preview_cutoff = 90,
          },
          horizontal = {
            height = 0.95,
            width = 0.99,
            preview_width = 0.55,
            prompt_position = 'top',
          },
        },
        winblend = vim.o.winblend,
        borderchars = {
          prompt = { '─', ' ', '─', ' ', '─', '─', ' ', ' ' },
          results = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
          preview = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
        },
        file_ignore_patterns = { '%.git$', 'node_modules' },
        set_env = {
          ['COLORTERM'] = 'truecolor',
        },
        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
          '--trim',
        },
        cache_picker = {
          num_pickers = 3,
        },
      }

      telescope.setup({
        defaults = defaults,
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = false,
            case_mode = 'smart_case',
          },
          ['zf-native'] = {
            file = {
              enable = true,
              highlight_results = true,
              match_filename = true,
            },
            generic = {
              enable = false,
              highlight_results = true,
              match_filename = false,
            },
          },
        },
        pickers = {
          buffers = themes.get_dropdown({
            mappings = {
              i = {
                ['<C-x>'] = actions.delete_buffer,
              },
              n = {
                ['<C-x>'] = actions.delete_buffer,
              },
            },
            borderchars = borderchars,
            ignore_current_buffer = true,
            sort_lastused = true,
            sort_mru = true,
            only_cwd = true,
            previewer = false,
          }),
          oldfiles = themes.get_dropdown({
            borderchars = borderchars,
            only_cwd = true,
            previewer = false,
          }),
          colorscheme = {
            enable_preview = true,
          },
          find_files = {
            find_command = { 'fd', '--type', 'f', '--strip-cwd-prefix' },
            hidden = true,
            mappings = {
              n = {
                ['cd'] = function(prompt_bufnr)
                  local selection = action_state.get_selected_entry()
                  local dir = vim.fn.fnamemodify(selection.path, ':p:h')
                  actions.close(prompt_bufnr)
                  vim.cmd.tcd({ dir, mods = { silent = true } })
                end,
              },
            },
          },
          git_files = {
            show_untracked = true,
          },
          git_bcommits = horizontal,
          git_commits = horizontal,
          git_status = horizontal,
          git_stash = horizontal,
          help_tags = horizontal,
        },
      })

      require('ky.abbrev').cabbrev('t', 'Telescope')

      local map = vim.keymap.set

      map('n', '<C-p>', function()
        local git_ok = pcall(builtin.git_files)
        if not git_ok then
          builtin.find_files()
        end
      end)
      map('n', '<C-b>', builtin.buffers)
      -- map('n', '<C-g>', builtin.live_grep)
      map('n', '<C-s>', builtin.grep_string)
      map('n', '<LocalLeader>fd', function()
        builtin.find_files({
          prompt_title = 'Dot Files',
          cwd = '$XDG_DATA_HOME/chezmoi/',
        })
      end)
      map('n', '<C-h>', builtin.help_tags)
      map('n', '<LocalLeader>fv', builtin.vim_options)
      map('n', '<LocalLeader>fc', builtin.commands)
      map('n', '<LocalLeader>fj', builtin.jumplist)
      -- map('n', '<LocalLeader>fm', builtin.marks)
      map('n', '<LocalLeader>fm', builtin.man_pages)
      map('n', '<LocalLeader>fh', builtin.highlights)
      map('n', '<C-n>', builtin.oldfiles)
      map('n', '<LocalLeader>fr', function()
        builtin.resume({ cache_index = vim.v.count1 })
      end)
      map('n', '<LocalLeader>gb', builtin.git_branches)
      map('n', '<LocalLeader>gc', builtin.git_bcommits)
      map('n', '<LocalLeader>gC', builtin.git_commits)
      map('n', '<LocalLeader>gs', builtin.git_status)
      map('n', '<LocalLeader>gS', builtin.git_stash)
      map('n', '<LocalLeader>ld', builtin.lsp_document_symbols)
      map('n', '<LocalLeader>lw', builtin.lsp_workspace_symbols)
      map('n', '<LocalLeader>ls', builtin.lsp_dynamic_workspace_symbols)
    end,
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    requires = 'nvim-telescope/telescope.nvim',
    run = 'make',
    config = function()
      require('telescope').load_extension('fzf')
    end,
  },
  {
    'natecraddock/telescope-zf-native.nvim',
    requires = 'nvim-telescope/telescope.nvim',
    config = function()
      require('telescope').load_extension('zf-native')
    end,
  },
  {
    'nvim-telescope/telescope-live-grep-args.nvim',
    requires = 'nvim-telescope/telescope.nvim',
    config = function()
      require('telescope').load_extension('frecency')
      vim.keymap.set('n', '<C-g>', function()
        require('telescope').extensions.live_grep_args.live_grep_args()
      end)
    end,
  },
  {
    'nvim-telescope/telescope-frecency.nvim',
    requires = { 'kkharji/sqlite.lua', 'nvim-telescope/telescope.nvim' },
    config = function()
      require('telescope').load_extension('frecency')
      vim.keymap.set('n', '<LocalLeader><LocalLeader>', function()
        require('telescope').extensions.frecency.frecency({
          path_display = { truncate = 3 },
        })
      end)
    end,
  },
  {
    'debugloop/telescope-undo.nvim',
    requires = 'nvim-telescope/telescope.nvim',
    config = function()
      require('telescope').load_extension('undo')
    end,
  },
  {
    'junegunn/fzf',
    run = function()
      vim.fn['fzf#install']()
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
    config = function()
      vim.keymap.set('n', '<LocalLeader>tq', vim.cmd.TodoQuickFix)
      vim.keymap.set('n', '<LocalLeader>tl', vim.cmd.TodoLocList)
      vim.keymap.set('n', ']t', require('todo-comments').jump_next)
      vim.keymap.set('n', '[t', require('todo-comments').jump_prev)

      require('todo-comments').setup()
    end,
  },
  'JoosepAlviste/nvim-ts-context-commentstring',

  -- Project
  {
    'ahmedkhalf/project.nvim',
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
    config_pre = function()
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
    config_pre = function()
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
    run = 'cd app && yarn install',
    cmd = 'MarkdownPreview',
  },
  {
    'AckslD/nvim-FeMaco.lua',
    config = function()
      require('femaco').setup()
    end,
  },

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
    config = function()
      require('session_manager').setup({
        autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir,
        autosave_ignore_filetypes = { 'gitcommit', 'gitrebase' },
      })
    end,
  },

  -- Marks
  {
    'ThePrimeagen/harpoon',
    config = function()
      require('harpoon').setup({
        global_settings = {
          enter_on_sendcmd = true,
        },
      })

      local map = vim.keymap.set

      map('n', [[<C-\>]], function()
        require('harpoon.term').gotoTerminal({
          idx = vim.api.nvim_tabpage_get_number(vim.api.nvim_get_current_tabpage()),
        })
      end, { desc = 'harpoon: create and go to terminal' })
      map('n', '<M-a>', function()
        require('harpoon.mark').add_file()
        vim.notify('harpoon.mark: mark added', vim.log.levels.INFO, { title = 'harpoon' })
      end, { desc = 'harpoon: add mark' })
      map(
        'n',
        '<M-t>u',
        require('harpoon.ui').toggle_quick_menu,
        { desc = 'harpoon: toggle quick menu' }
      )
      map(
        'n',
        '<M-t>c',
        require('harpoon.cmd-ui').toggle_quick_menu,
        { desc = 'harpoon: toggle quick cmd menu' }
      )
      for i = 1, 5 do
        map('n', string.format('<M-%s>', i), function()
          require('harpoon.ui').nav_file(i)
        end, { desc = 'navigate to file' })
      end
      for i = 1, 5 do
        map('n', string.format('<M-c>%s', i), function()
          require('harpoon.term').gotoTerminal(vim.v.count1)
          require('harpoon.term').sendCommand(vim.v.count1, i)
        end, { desc = string.format('harpoon: go to terminal %s and execute command', i) })
      end
    end,
  },
  -- {
  --   'chentoast/marks.nvim',
  --   config = function()
  --     require('marks').setup({
  --       default_mappings = false,
  --       -- builtin_marks = { '.', '^', "'", '"' },
  --       excluded_filetypes = {
  --         '',
  --         'gitcommit',
  --         'gitrebase',
  --         'lspinfo',
  --         'null-ls-info',
  --       },
  --     })
  --   end,
  -- },

  -- Quickfix
  {
    'kevinhwang91/nvim-bqf',
    config = function()
      require('bqf').setup({
        preview = {
          border_chars = { '│', '│', '─', '─', '┌', '┐', '└', '┘', '█' },
        },
        filter = {
          fzf = {
            extra_opts = { '--bind', 'ctrl-o:toggle-all', '--delimiter', '│' },
          },
        },
      })
    end,
  },

  -- UI
  {
    'rcarriga/nvim-notify',
    config = function()
      local notify = require('notify')
      local render = require('notify.render')

      notify.setup({
        timeout = 1000,
        render = function(bufnr, notif, highlights, config)
          local renderer = notif.title[1] == '' and 'minimal' or 'simple'
          render[renderer](bufnr, notif, highlights, config)
        end,
        on_open = function(win)
          vim.api.nvim_win_set_option(win, 'wrap', true)
        end,
        stages = 'fade',
        top_down = false,
      })
    end,
  },
  'vigoux/notifier.nvim',
  {
    'folke/noice.nvim',
    requires = 'MunifTanjim/nui.nvim',
    config = function()
      require('noice').setup({
        lsp = {
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = true,
        },
        routes = {
          {
            filter = {
              event = 'msg_show',
              kind = '',
              find = 'written',
            },
            opts = { skip = true },
          },
          {
            filter = {
              event = 'notify',
              find = 'No information available',
            },
            opts = { skip = true },
          },
        },
      })
      require('ky.abbrev').cabbrev('n', 'Noice')
    end,
  },

  -- Utility
  'nvim-lua/plenary.nvim',
  'lewis6991/impatient.nvim',
  {
    'tyru/open-browser.vim',
    config_pre = function()
      vim.keymap.set({ 'n', 'x' }, 'gx', '<Plug>(openbrowser-smart-search)')
      require('ky.abbrev').cabbrev('ob', 'OpenBrowserSmartSearch')
    end,
  },
  {
    'lambdalisue/suda.vim',
    config_pre = function()
      vim.g.suda_smart_edit = 1
    end,
  },
  { 'psliwka/vim-dirtytalk', run = ':DirtytalkUpdate' },
  {
    'nacro90/numb.nvim',
    config = function()
      require('numb').setup()
    end,
  },
  'wsdjeg/vim-fetch',
  'justinmk/vim-gtfo',
  { 'dstein64/vim-startuptime', cmd = 'StartupTime' },
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      require('treesitter-context').setup()
    end,
  },
  {
    'samjwill/nvim-unception',
    config_pre = function()
      vim.g.unception_open_buffer_in_new_tab = true
      vim.g.unception_enable_flavor_text = false
    end,
  },
  -- {
  --   'cbochs/portal.nvim',
  --   config = function()
  --     require('portal').setup({})
  --     vim.keymap.set('n', '<LocalLeader>o', require('portal').jump_backward, {})
  --     vim.keymap.set('n', '<LocalLeader>i', require('portal').jump_forward, {})
  --   end,
  -- },
  {
    'kevinhwang91/nvim-fundo',
    requires = 'kevinhwang91/promise-async',
    run = function()
      require('fundo').install()
    end,
    config = function()
      require('fundo').setup()
    end,
  },
  {
    'mbbill/undotree',
    config_pre = function()
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_SplitWidth = 40
      vim.g.undotree_WindowLayout = 2
      vim.keymap.set('n', '<LocalLeader>u', vim.cmd.UndotreeToggle)
    end,
  },
})

vim.keymap.set('n', '<LocalLeader>pC', vim.cmd.PackerClean)
vim.keymap.set('n', '<LocalLeader>pS', vim.cmd.PackerStatus)
vim.keymap.set('n', '<LocalLeader>pi', vim.cmd.PackerInstall)
vim.keymap.set('n', '<LocalLeader>ps', vim.cmd.PackerSync)
vim.keymap.set('n', '<LocalLeader>pu', vim.cmd.PackerUpdate)
