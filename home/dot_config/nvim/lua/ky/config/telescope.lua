local telescope = require('telescope')
local actions = require('telescope.actions')
local actions_layout = require('telescope.actions.layout')

local defaults = {
  mappings = {
    i = {
      ['<C-j>'] = actions.cycle_history_next,
      ['<C-k>'] = actions.cycle_history_prev,
      ['<M-m>'] = actions_layout.toggle_mirror,
      ['<M-p>'] = actions_layout.toggle_preview,
    },
    n = {
      ['q'] = actions.close,
    },
  },
  path_display = { 'smart', 'absolute', 'truncate' },
  prompt_prefix = '   ',
  sorting_strategy = 'ascending',
  layout_strategy = 'bottom_pane',
  layout_config = {
    height = 25,
    preview_cutoff = 100,
  },
  borderchars = {
    prompt = { '─', ' ', ' ', ' ', '─', '─', ' ', ' ' },
    results = { '─', ' ', ' ', ' ', '─', '─', ' ', ' ' },
    preview = { ' ' },
  },
  width = 0.8,
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
          ['<C-x>'] = actions.delete_buffer,
        },
        n = {
          ['<C-x>'] = actions.delete_buffer,
        },
      },
    },
    colorscheme = {
      enable_preview = true,
    },
    find_files = {
      find_command = { 'fd', '--type', 'f', '--strip-cwd-prefix' },
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

local map = vim.keymap.set

map('n', '<C-p>', '<Nop>', { remap = true })
map('n', '<C-p>', function()
  local ok = pcall(require('telescope.builtin').git_files)
  if not ok then
    require('telescope.builtin').find_files {
      find_command = { 'fd', '--type', 'f', '--strip-cwd-prefix' },
      hidden = true,
    }
  end
end)
map('n', '<C-b>', '<Nop>')
map('n', '<C-b>', function()
  require('telescope.builtin').buffers {
    -- sort_lastused = true,
    -- sort_mru = true,
    only_cwd = true
  }
end)
map('n', '<C-g>', '<Nop>', { remap = true })
map('n', '<C-g>', require('telescope.builtin').live_grep)
map('n', '<C-s>', require('telescope.builtin').grep_string)
map('n', '<LocalLeader>fd', function()
  require('telescope.builtin').find_files {
    prompt_title = 'Dot Files',
    find_command = { 'fd', '--type', 'f', '--strip-cwd-prefix' },
    cwd = '$XDG_DATA_HOME/chezmoi/',
    hidden = true,
  }
end)
map('n', '<C-h>', '<Nop>', { remap = true })
map('n', '<C-h>', require('telescope.builtin').help_tags)
map('n', '<LocalLeader>fv', require('telescope.builtin').vim_options)
map('n', '<LocalLeader>fc', require('telescope.builtin').commands)
map('n', '<LocalLeader>fj', require('telescope.builtin').jumplist)
-- map('n', '<LocalLeader>fm', require('telescope.builtin').marks)
map('n', '<LocalLeader>fm', require('telescope.builtin').man_pages)
map('n', '<LocalLeader>fo', function()
  require('telescope.builtin').oldfiles{
    only_cwd = true
  }
end)
map('n', '<LocalLeader>fr', require('telescope.builtin').resume)
map('n', '<LocalLeader>gb', require('telescope.builtin').git_branches)
map('n', '<LocalLeader>gc', require('telescope.builtin').git_commits)
map('n', '<LocalLeader>gC', require('telescope.builtin').git_bcommits)
map('n', '<LocalLeader>gs', require('telescope.builtin').git_status)
map('n', '<LocalLeader>gS', require('telescope.builtin').git_stash)
