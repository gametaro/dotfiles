local telescope = require('telescope')
local actions = require('telescope.actions')
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
  sorting_strategy = 'descending',
}

local defaults = {
  mappings = {
    i = {
      ['<C-j>'] = actions.cycle_history_next,
      ['<C-k>'] = actions.cycle_history_prev,
      ['<M-m>'] = actions_layout.toggle_mirror,
      ['<M-p>'] = actions_layout.toggle_preview,
      ['<C-s>'] = actions.select_horizontal,
      ['<C-x>'] = false,
    },
    n = {
      ['<C-s>'] = actions.select_horizontal,
      ['<C-x>'] = false,
    },
  },
  path_display = { truncate = 3 },
  prompt_prefix = ' ',
  dynamic_preview_title = true,
  results_title = false,
  sorting_strategy = 'ascending',
  layout_strategy = 'bottom_pane',
  layout_config = {
    height = 0.5,
    preview_cutoff = 100,
    bottom_pane = {
      preview_width = 0.55,
    },
    horizontal = {
      height = 0.95,
      width = 0.95,
      preview_width = 0.55,
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

telescope.setup {
  defaults = defaults,
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    },
    ['zf-native'] = {
      -- options for sorting file-like items
      file = {
        -- override default telescope file sorter
        enable = false,

        -- highlight matching text in results
        highlight_results = true,

        -- enable zf filename match priority
        match_filename = true,
      },

      -- options for sorting all other items
      generic = {
        -- override default telescope generic item sorter
        enable = false,

        -- highlight matching text in results
        highlight_results = true,

        -- disable zf filename match priority
        match_filename = false,
      },
    },
  },
  pickers = {
    buffers = themes.get_dropdown {
      mappings = {
        i = {
          ['<C-x>'] = actions.delete_buffer,
        },
        n = {
          ['<C-x>'] = actions.delete_buffer,
        },
      },
      borderchars = borderchars,
      sort_lastused = true,
      sort_mru = true,
      only_cwd = true,
      previewer = false,
    },
    oldfiles = themes.get_dropdown {
      borderchars = borderchars,
      only_cwd = true,
      previewer = false,
    },
    colorscheme = {
      enable_preview = true,
    },
    find_files = {
      find_command = { 'fd', '--type', 'f', '--strip-cwd-prefix' },
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
    git_bcommits = horizontal,
    git_commits = horizontal,
    git_status = horizontal,
    git_stash = horizontal,
  },
}

local map = vim.keymap.set

map('n', '<C-p>', function()
  local ok = pcall(builtin.git_files)
  if not ok then
    builtin.find_files()
  end
end)
map('n', '<C-b>', builtin.buffers)
-- map('n', '<C-g>', builtin.live_grep)
map('n', '<C-s>', builtin.grep_string)
map('n', '<LocalLeader>fd', function()
  builtin.find_files {
    prompt_title = 'Dot Files',
    cwd = '$XDG_DATA_HOME/chezmoi/',
  }
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
  builtin.resume { cache_index = vim.v.count1 }
end)
map('n', '<LocalLeader>gb', builtin.git_branches)
map('n', '<LocalLeader>gc', builtin.git_bcommits)
map('n', '<LocalLeader>gC', builtin.git_commits)
map('n', '<LocalLeader>gs', builtin.git_status)
map('n', '<LocalLeader>gS', builtin.git_stash)
map('n', '<LocalLeader>ld', builtin.lsp_document_symbols)
map('n', '<LocalLeader>lw', builtin.lsp_workspace_symbols)
map('n', '<LocalLeader>ls', builtin.lsp_dynamic_workspace_symbols)
