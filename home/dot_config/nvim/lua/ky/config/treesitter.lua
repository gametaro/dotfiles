require('nvim-treesitter.configs').setup {
  -- ensure_installed = 'maintained',
  highlight = { enable = true },
  incremental_selection = { enable = false },
  indent = { enable = true },
  autotag = { enable = true },
  context_commentstring = { enable = true, enable_autocmd = false },
  rainbow = { enable = true, extended_mode = true, max_file_length = 1000 },
  textsubjects = {
    enable = true,
    keymaps = { ['.'] = 'textsubjects-smart' },
  },
  matchup = {
    enable = true, -- mandatory, false will disable the whole extension
    -- [options]
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
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['aC'] = '@class.outer',
        ['iC'] = '@class.inner',
        -- ['a,'] = '@parameter.outer',
        -- ['i,'] = '@parameter.inner',
        ['ac'] = '@comment.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = { ['<leader>>'] = '@parameter.inner' },
      swap_previous = { ['<leader><'] = '@parameter.inner' },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    lsp_interop = {
      enable = false,
      border = 'none',
      peek_definition_code = {
        ['df'] = '@function.outer',
      },
    },
  },
}

-- vim.opt.foldexpr = [[nvim_treesitter#foldexpr()]]
