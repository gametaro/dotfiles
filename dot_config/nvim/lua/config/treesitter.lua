require('nvim-treesitter.configs').setup {
  -- ensure_installed = 'maintained',
  highlight = { enable = true },
  incremental_selection = { enable = false },
  indent = { enable = true },
  autotag = { enable = true },
  context_commentstring = { enable = true, enable_autocmd = false },
  rainbow = { enable = true, extended_mode = true, max_file_length = 1000 },
  refactor = { highlight_definitions = { enable = true } },
  textsubjects = {
    enable = true,
    keymaps = { ['.'] = 'textsubjects-smart' },
  },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['as'] = '@statement.outer',
        ['a,'] = '@parameter.outer',
        ['i,'] = '@parameter.inner',
        ['a/'] = '@comment.outer',
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
        [']f'] = '@function.outer',
      },
      goto_next_end = {
        [']F'] = '@function.outer',
      },
      goto_previous_start = {
        ['[f'] = '@function.outer',
      },
      goto_previous_end = {
        ['[F'] = '@function.outer',
      },
    },
    lsp_interop = {
      enable = true,
      border = 'rounded',
      peek_definition_code = {
        ['df'] = '@function.outer',
      },
    },
  },
}

-- vim.o.foldmethod = [[expr]]
-- vim.o.foldexpr = [[nvim_treesitter#foldexpr()]]
