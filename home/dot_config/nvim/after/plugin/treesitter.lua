local ok = prequire('nvim-treesitter')
if not ok then return end

require('nvim-treesitter.configs').setup {
  auto_install = true,
  ignore_install = { 'comment' },
  highlight = {
    enable = true,
    disable = { 'html' },
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
    enable = true, -- mandatory, false will disable the whole extension
    -- [options]
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
      border = require('ky.ui').border,
      peek_definition_code = {
        ['df'] = '@function.outer',
      },
    },
  },
}
