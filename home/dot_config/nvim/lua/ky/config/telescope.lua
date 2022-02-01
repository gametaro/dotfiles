local telescope = require('telescope')
local actions = require('telescope.actions')
local themes = require('telescope.themes')

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
  prompt_prefix = '   ',
  preview_title = '',
  prompt_title = '',
  results_title = '',
  borderchars = {
    preview = { '', '', '', '', '', '', '', '' },
  },
  width = 0.8,
  file_ignore_patterns = { '%.git', 'node_modules' },
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
