local telescope = require 'telescope'
local actions = require 'telescope.actions'
local themes = require 'telescope.themes'

local defaults = themes.get_ivy {
  winblend = 10,
  path_display = { 'smart' },
  history = {
    path = '~/.local/share/nvim/databases/telescope_history.sqlite3',
    limit = 100,
  },
}

telescope.setup {
  defaults = defaults,
  extensions = {
    ['ui-select'] = {
      themes.get_cursor {},
    },
  },
  pickers = {
    buffers = {
      show_all_buffers = true,
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
  },
}

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

map('n', '<leader>fb', '<Cmd>lua require("telescope.builtin").buffers()<CR>', opts)
map('n', '<leader>fc', '<Cmd>lua require("telescope.builtin").commands()<CR>', opts)
map('n', '<leader>ff', '<Cmd>lua require("telescope.builtin").find_files()<CR>', opts)
map('n', '<leader>fg', '<Cmd>lua require("telescope.builtin").live_grep()<CR>', opts)
map('n', '<leader>fh', '<Cmd>lua require("telescope.builtin").help_tags()<CR>', opts)
map('n', '<leader>fm', '<Cmd>lua require("telescope.builtin").marks()<CR>', opts)
map('n', '<leader>fo', '<Cmd>lua require("telescope.builtin").oldfiles()<CR>', opts)
map('n', '<leader>fq', '<Cmd>lua require("telescope.builtin").quickfix()<CR>', opts)
map('n', '<leader>fr', '<Cmd>lua require("telescope.builtin").resume()<CR>', opts)
map('n', '<leader>fs', '<Cmd>lua require("telescope.builtin").grep_string()<CR>', opts)
map('n', '<leader>lc', '<Cmd>lua require("telescope.builtin").lsp_code_actions()<CR>', opts)
map('n', '<leader>ld', '<Cmd>lua require("telescope.builtin").lsp_document_diagnostics()<CR>', opts)
map('n', '<leader>lw', '<Cmd>lua require("telescope.builtin").lsp_workspace_diagnostics()<CR>', opts)
map('n', '<leader>gb', '<Cmd>lua require("telescope.builtin").git_branches()<CR>', opts)
map('n', '<leader>gc', '<Cmd>lua require("telescope.builtin").git_commits()<CR>', opts)
map('n', '<leader>gC', '<Cmd>lua require("telescope.builtin").git_bcommits()<CR>', opts)
map('n', '<leader>gf', '<Cmd>lua require("telescope.builtin").git_files()<CR>', opts)
map('n', '<leader>gs', '<Cmd>lua require("telescope.builtin").git_status()<CR>', opts)
map('n', '<leader>gS', '<Cmd>lua require("telescope.builtin").git_stash()<CR>', opts)
map(
  'n',
  '<leader><leader>',
  "<Cmd>lua require('telescope').extensions.frecency.frecency()<CR>",
  { noremap = true, silent = true }
)
