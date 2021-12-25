local telescope = require 'telescope'
local actions = require 'telescope.actions'
local themes = require 'telescope.themes'

local defaults = themes.get_ivy {
  mappings = {
    i = {
      ['<C-w>'] = function()
        vim.cmd [[normal! bcw]]
      end,
    },
  },
  winblend = 10,
  path_display = { 'smart' },
  history = {
    path = '~/.local/share/nvim/databases/telescope_history.sqlite3',
    limit = 100,
  },
  layout_config = {
    preview_cutoff = 20,
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
}

telescope.setup {
  defaults = defaults,
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
map(
  'n',
  '<LocalLeader><LocalLeader>',
  "<Cmd>lua require('telescope').extensions.frecency.frecency()<CR>",
  { noremap = true, silent = true }
)
