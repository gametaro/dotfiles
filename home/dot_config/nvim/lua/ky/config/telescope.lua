local telescope = require 'telescope'
local actions = require 'telescope.actions'

local defaults = {
  mappings = {
    i = {
      ['<C-j>'] = actions.cycle_history_next,
      ['<C-k>'] = actions.cycle_history_prev,
      ['<Esc>'] = actions.close,
      ['<C-w>'] = function()
        vim.api.nvim_input '<C-S-w>'
      end,
      ['<C-c>'] = function()
        local t = vim.api.nvim_replace_termcodes('<Esc>', true, true, true)
        vim.api.nvim_feedkeys(t, 'n', true)
      end,
    },
    n = {
      ['q'] = actions.close,
    },
  },
  path_display = { 'smart', 'absolute', 'truncate' },
  history = {
    path = '~/.local/share/nvim/databases/telescope_history.sqlite3',
    limit = 100,
  },
  prompt_prefix = '   ',
  selection_caret = '  ',
  entry_prefix = '  ',
  selection_strategy = 'reset',
  sorting_strategy = 'ascending',
  layout_strategy = 'horizontal',
  layout_config = {
    horizontal = {
      prompt_position = 'top',
      preview_width = 0.55,
      results_width = 0.8,
    },
    vertical = {
      mirror = false,
    },
    width = 0.80,
    height = 0.80,
    preview_cutoff = 120,
  },
  vimgrep_arguments = {
    'rg',
    '--color=never',
    '--no-heading',
    '--with-filename',
    '--line-number',
    '--column',
    '--smart-case',
    '--hidden',
  },
  file_ignore_patterns = { '^.git/', '^.node_modules/' },
  set_env = {
    ['COLORTERM'] = 'truecolor',
  },
}

telescope.setup {
  defaults = defaults,
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    },
  },
  pickers = {
    buffers = {
      ignore_current_buffer = true,
      sort_lastused = true,
      sort_mru = true,
      mappings = {
        i = {
          ['<c-d>'] = actions.delete_buffer,
        },
        n = {
          ['<c-d>'] = actions.delete_buffer,
        },
      },
    },
    colorscheme = {
      enable_preview = true,
    },
    git_branches = {
      theme = 'dropdown',
    },
    find_files = {
      hidden = true,
      mappings = {
        n = {
          ['cd'] = function(prompt_bufnr)
            local selection = require('telescope.actions.state').get_selected_entry()
            local dir = vim.fn.fnamemodify(selection.path, ':p:h')
            require('telescope.actions').close(prompt_bufnr)
            vim.cmd(string.format('silent tcd %s', dir))
          end,
        },
      },
    },
  },
}

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

map('n', '<Localleader>fb', '<Cmd>lua require("telescope.builtin").buffers()<CR>', opts)
map('n', '<LocalLeader>fc', '<Cmd>lua require("telescope.builtin").commands()<CR>', opts)
map('n', '<LocalLeader>ff', '<Cmd>lua require("telescope.builtin").find_files()<CR>', opts)
map('n', '<LocalLeader>fg', '<Cmd>lua require("telescope.builtin").live_grep()<CR>', opts)
map('n', '<LocalLeader>fh', '<Cmd>lua require("telescope.builtin").help_tags()<CR>', opts)
map('n', '<LocalLeader>fm', '<Cmd>lua require("telescope.builtin").marks()<CR>', opts)
map('n', '<LocalLeader>fo', '<Cmd>lua require("telescope.builtin").oldfiles()<CR>', opts)
map('n', '<LocalLeader>fq', '<Cmd>lua require("telescope.builtin").quickfix()<CR>', opts)
map('n', '<LocalLeader>fr', '<Cmd>lua require("telescope.builtin").resume()<CR>', opts)
map('n', '<LocalLeader>fs', '<Cmd>lua require("telescope.builtin").grep_string()<CR>', opts)
map('n', '<LocalLeader>fl', '<Cmd>lua require("telescope.builtin").diagnostics()<CR>', opts)
-- FIXME: conflicting with neogit and diffview
map('n', '<LocalLeader>gb', '<Cmd>lua require("telescope.builtin").git_branches()<CR>', opts)
-- map('n', '<LocalLeader>gc', '<Cmd>lua require("telescope.builtin").git_commits()<CR>', opts)
map('n', '<LocalLeader>gC', '<Cmd>lua require("telescope.builtin").git_bcommits()<CR>', opts)
-- map('n', '<LocalLeader>gf', '<Cmd>lua require("telescope.builtin").git_files()<CR>', opts)
-- map('n', '<LocalLeader>gs', '<Cmd>lua require("telescope.builtin").git_status()<CR>', opts)
map('n', '<LocalLeader>gS', '<Cmd>lua require("telescope.builtin").git_stash()<CR>', opts)
map('n', '<LocalLeader><LocalLeader>', "<Cmd>lua require('telescope').extensions.frecency.frecency()<CR>", opts)
