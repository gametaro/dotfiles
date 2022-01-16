local telescope = require 'telescope'
local actions = require 'telescope.actions'
local themes = require 'telescope.themes'

local defaults = themes.get_ivy {
  mappings = {
    i = {
      ['<C-j>'] = actions.cycle_history_next,
      ['<C-k>'] = actions.cycle_history_prev,
    },
    n = {
      ['q'] = actions.close,
    },
  },
  path_display = { 'smart', 'absolute', 'truncate' },
  history = {
    path = vim.fn.stdpath 'data' .. '/databases/telescope_history.sqlite3',
    limit = 100,
  },
  prompt_prefix = '   ',
  preview_title = '',
  prompt_title = '',
  results_title = '',
  borderchars = {
    preview = { '', '', '', '', '', '', '', '' },
  },
  width = 0.8,
  file_ignore_patterns = { '.git/', '.node_modules/' },
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
    find_files = {
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

vim.keymap.set('n', '<LocalLeader>fb', function()
  require('telescope.builtin').buffers {
    ignore_current_buffer = true,
    sort_lastused = true,
    sort_mru = true,
  }
end)
vim.keymap.set('n', '<LocalLeader>fj', function()
  require('telescope.builtin').jumplist()
end)
vim.keymap.set('n', '<LocalLeader>fc', function()
  require('telescope.builtin').commands()
end)
vim.keymap.set('n', '<LocalLeader>ff', function()
  require('telescope.builtin').find_files {
    hidden = true,
  }
end)
vim.keymap.set('n', '<LocalLeader>fg', function()
  require('telescope.builtin').live_grep()
end)
vim.keymap.set('n', '<LocalLeader>fh', function()
  require('telescope.builtin').help_tags()
end)
vim.keymap.set('n', '<LocalLeader>fm', function()
  require('telescope.builtin').marks()
end)
vim.keymap.set('n', '<LocalLeader>fo', function()
  require('telescope.builtin').oldfiles()
end)
vim.keymap.set('n', '<LocalLeader>fq', function()
  require('telescope.builtin').quickfix()
end)
vim.keymap.set('n', '<LocalLeader>fr', function()
  require('telescope.builtin').resume()
end)
vim.keymap.set('n', '<LocalLeader>fs', function()
  require('telescope.builtin').grep_string()
end)
vim.keymap.set('n', '<LocalLeader>fl', function()
  require('telescope.builtin').diagnostics()
end)
-- FIXME: conflicting with neogit and diffview
vim.keymap.set('n', '<LocalLeader>gb', function()
  require('telescope.builtin').git_branches()
end)
-- map('n', '<LocalLeader>gc', '<Cmd>lua require("telescope.builtin").git_commits()<CR>', opts)
vim.keymap.set('n', '<LocalLeader>gC', function()
  require('telescope.builtin').git_bcommits()
end)
-- map('n', '<LocalLeader>gf', '<Cmd>lua require("telescope.builtin").git_files()<CR>', opts)
-- map('n', '<LocalLeader>gs', '<Cmd>lua require("telescope.builtin").git_status()<CR>', opts)
vim.keymap.set('n', '<LocalLeader>gS', function()
  require('telescope.builtin').git_stash()
end)
vim.keymap.set('n', '<LocalLeader><LocalLeader>', function()
  require('telescope').extensions.frecency.frecency()
end)
