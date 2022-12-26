return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    'JoosepAlviste/nvim-ts-context-commentstring',
    'windwp/nvim-ts-autotag',
    'nvim-treesitter/playground',
    'p00f/nvim-ts-rainbow',
    { 'nvim-treesitter/nvim-treesitter-context', config = true },
    {
      'mfussenegger/nvim-treehopper',
      init = function()
        vim.keymap.set('o', 'm', ':<C-u>lua require("tsht").nodes()<CR>')
        vim.keymap.set('x', 'm', ':lua require("tsht").nodes()<CR>')
      end,
      config = function()
        require('tsht').config.hint_keys = { 'h', 'j', 'f', 'd', 'n', 'v', 's', 'l', 'a' }
      end,
    },
    {
      'David-Kunz/treesitter-unit',
      init = function()
        vim.keymap.set('x', 'iu', ':lua require"treesitter-unit".select()<CR>')
        vim.keymap.set('x', 'au', ':lua require"treesitter-unit".select(true)<CR>')
        vim.keymap.set('o', 'iu', ':<c-u>lua require"treesitter-unit".select()<CR>')
        vim.keymap.set('o', 'au', ':<c-u>lua require"treesitter-unit".select(true)<CR>')
      end,
    },
  },
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
}
