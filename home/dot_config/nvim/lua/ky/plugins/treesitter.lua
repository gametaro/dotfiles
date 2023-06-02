return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  event = { 'FileType' },
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
    { 'windwp/nvim-ts-autotag' },
    { 'nvim-treesitter/nvim-treesitter-context', enabled = false, config = true },
    {
      'mfussenegger/nvim-treehopper',
      init = function()
        vim.keymap.set('o', 'm', ':<C-u>lua require("tsht").nodes()<CR>', { silent = true })
        vim.keymap.set('x', 'm', ':lua require("tsht").nodes()<CR>', { silent = true })
      end,
      config = function()
        require('tsht').config.hint_keys = { 'h', 'j', 'f', 'd', 'n', 'v', 's', 'l', 'a' }
      end,
    },
  },
  config = function()
    local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
    parser_config.gotmpl = {
      install_info = {
        url = 'https://github.com/ngalaiko/tree-sitter-go-template',
        files = { 'src/parser.c' },
      },
      filetype = 'gotmpl',
      used_by = { 'gohtmltmpl', 'gotexttmpl', 'gotmpl' },
    }
    require('nvim-treesitter.configs').setup({
      auto_install = true,
      ignore_install = { 'comment' },
      highlight = {
        enable = true,
        disable = function(lang, bufnr)
          return vim.api.nvim_buf_line_count(bufnr) > vim.g.max_line_count
        end,
      },
      incremental_selection = {
        enable = false,
        keymaps = {
          init_selection = 'gnn',
          node_incremental = 'grn',
          scope_incremental = 'grc',
          node_decremental = 'grm',
        },
      },
      indent = {
        enable = true,
      },
      matchup = {
        enable = false,
      },
      autotag = {
        enable = true,
      },
      textobjects = {
        select = {
          enable = false,
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
      },
    })
  end,
}
