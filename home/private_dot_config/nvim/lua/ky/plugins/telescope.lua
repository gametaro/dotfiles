return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = not require('ky.util').is_win,
    },
    {
      'nvim-telescope/telescope-fzy-native.nvim',
      cond = require('ky.util').is_win,
    },
    { 'natecraddock/telescope-zf-native.nvim' },
    { 'debugloop/telescope-undo.nvim' },
    { 'nvim-telescope/telescope-live-grep-args.nvim' },
    { 'marcuscaisey/olddirs.nvim' },
    { 'tsakirist/telescope-lazy.nvim' },
  },
  event = 'VeryLazy',
  config = function()
    local telescope = require('telescope')
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')
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
    }

    local yank = function(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      if selection == nil then
        return
      end
      actions.close(prompt_bufnr)
      vim.fn.setreg(vim.v.register, selection.value)
    end

    local defaults = {
      mappings = {
        i = {
          ['<C-j>'] = actions.cycle_history_next,
          ['<C-k>'] = actions.cycle_history_prev,
          ['<M-m>'] = actions_layout.toggle_mirror,
          ['<M-p>'] = actions_layout.toggle_preview,
          ['<C-s>'] = actions.select_horizontal,
          ['<C-x>'] = false,
          -- ['<C-f>'] = actions.preview_scrolling_down,
          -- ['<C-b>'] = actions.preview_scrolling_up,
          -- ['<C-u>'] = { '<C-u>', type = 'command' },
          ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
          ['<C-l>'] = actions.smart_send_to_loclist + actions.open_loclist,
          ['<C-y>'] = yank,
        },
        n = {
          ['<C-s>'] = actions.select_horizontal,
          ['<C-x>'] = false,
          ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
          ['<C-l>'] = actions.smart_send_to_loclist + actions.open_loclist,
          ['y'] = yank,
        },
      },
      path_display = { truncate = 3 },
      -- prompt_prefix = ' ',
      selection_caret = '  ',
      dynamic_preview_title = true,
      results_title = false,
      sorting_strategy = 'ascending',
      layout_strategy = 'bottom_pane',
      layout_config = {
        bottom_pane = {
          height = 0.4,
          preview_width = 0.55,
          preview_cutoff = 90,
        },
        horizontal = {
          height = 0.95,
          width = 0.99,
          preview_width = 0.55,
          prompt_position = 'top',
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
      vimgrep_arguments = vim.fn.executable('git') == 1 and require('ky.util').is_git_repo() and {
        'git',
        '--no-pager',
        'grep',
        '-I',
        '-E',
        '--no-color',
        '--line-number',
        '--column',
      } or {
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

    telescope.setup({
      defaults = defaults,
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = false,
          case_mode = 'smart_case',
        },
        fzy_native = {
          override_generic_sorter = true,
          override_file_sorter = false,
        },
        ['zf-native'] = {
          file = {
            enable = true,
            highlight_results = true,
            match_filename = true,
          },
          generic = {
            enable = false,
            highlight_results = true,
            match_filename = false,
          },
        },
        olddirs = {
          selected_dir_callback = vim.cmd.edit,
        },
      },
      pickers = {
        buffers = themes.get_dropdown({
          mappings = {
            i = {
              ['<C-x>'] = actions.delete_buffer,
            },
            n = {
              ['<C-x>'] = actions.delete_buffer,
            },
          },
          borderchars = borderchars,
          ignore_current_buffer = true,
          sort_lastused = true,
          sort_mru = true,
          only_cwd = true,
          previewer = false,
        }),
        oldfiles = themes.get_dropdown({
          borderchars = borderchars,
          only_cwd = true,
          previewer = false,
        }),
        colorscheme = {
          enable_preview = true,
        },
        find_files = {
          hidden = true,
          mappings = {
            n = {
              ['cd'] = function(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                local dir = vim.fn.fnamemodify(selection.path, ':p:h')
                actions.close(prompt_bufnr)
                vim.cmd.tcd({ dir, mods = { silent = true } })
              end,
            },
          },
        },
        git_files = {
          show_untracked = true,
        },
        git_bcommits = horizontal,
        git_commits = horizontal,
        git_status = horizontal,
        git_stash = horizontal,
        help_tags = horizontal,
      },
    })

    require('ky.abbrev').cabbrev('t', 'Telescope')

    local map = vim.keymap.set

    map('n', '<C-p>', function()
      local git_ok = pcall(builtin.git_files)
      if not git_ok then
        builtin.find_files()
      end
    end, { desc = 'Find files' })
    map('n', '<C-b>', builtin.buffers, { desc = 'Buffers' })
    -- map('n', '<C-g>', builtin.live_grep)
    map('n', '<C-s>', builtin.grep_string, { desc = 'Search cursor word' })
    map('n', '<Leader>fd', function()
      builtin.find_files({
        prompt_title = 'Dot Files',
        cwd = '$XDG_DATA_HOME/chezmoi/',
      })
    end, { desc = 'Find in Dotfiles' })
    map('n', '<C-h>', builtin.help_tags, { desc = 'Help' })
    map('n', '<Leader>fv', builtin.vim_options, { desc = 'Options' })
    map('n', '<Leader>fc', builtin.commands, { desc = 'Commands' })
    map('n', '<Leader>fj', builtin.jumplist, { desc = 'Jumplist' })
    -- map('n', '<Leader>fm', builtin.marks)
    map('n', '<Leader>fm', builtin.man_pages, { desc = 'Man pages' })
    map('n', '<Leader>fh', builtin.highlights, { desc = 'Highlights' })
    map('n', '<C-n>', builtin.oldfiles, { desc = 'Oldfiles' })
    map('n', '<Leader>fr', function()
      builtin.resume({ cache_index = vim.v.count1 })
    end, { desc = 'Resume picker' })
    map('n', '<Leader>gb', builtin.git_branches, { desc = 'Branches' })
    map('n', '<Leader>gc', builtin.git_bcommits, { desc = 'Bcommits' })
    map('n', '<Leader>gC', builtin.git_commits, { desc = 'Commits' })
    map('n', '<Leader>gs', builtin.git_status, { desc = 'Status' })
    map('n', '<Leader>gS', builtin.git_stash, { desc = 'Stash' })
    map('n', '<Leader>ld', builtin.lsp_document_symbols, { desc = 'Document symbols' })
    map('n', '<Leader>lw', builtin.lsp_workspace_symbols, { desc = 'Workspace symbols' })
    map(
      'n',
      '<Leader>ls',
      builtin.lsp_dynamic_workspace_symbols,
      { desc = 'Dynamic Workspace symbols' }
    )

    require('telescope').load_extension('fzf')
    require('telescope').load_extension('zf-native')
    require('telescope').load_extension('live_grep_args')
    vim.keymap.set('n', '<C-g>', function()
      require('telescope').extensions.live_grep_args.live_grep_args()
    end, { desc = 'Search' })

    require('telescope').load_extension('undo')
    vim.keymap.set('n', '<Leader>fu', telescope.extensions.undo.undo, { desc = 'Undo' })
    require('telescope').load_extension('olddirs')
    vim.keymap.set('n', '<Leader>od', telescope.extensions.olddirs.picker, { desc = 'Olddirs' })
    vim.keymap.set('n', '<Leader>ofd', function()
      telescope.extensions.olddirs.picker({
        selected_dir_callback = function(dir)
          builtin.find_files({
            prompt_title = 'Find Files in ' .. dir,
            cwd = dir,
          })
        end,
      })
    end, { desc = 'Find in Olddirs' })
    vim.keymap.set('n', '<Leader>ogd', function()
      telescope.extensions.olddirs.picker({
        selected_dir_callback = function(dir)
          builtin.live_grep({
            prompt_title = 'Live Grep in ' .. dir,
            search_dirs = { dir },
          })
        end,
      })
    end, { desc = 'Search in Olddirs' })
    require('telescope').load_extension('lazy')
  end,
}
