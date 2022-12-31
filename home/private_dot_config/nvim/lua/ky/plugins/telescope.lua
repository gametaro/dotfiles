return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    { 'nvim-telescope/telescope-frecency.nvim', dependencies = 'kkharji/sqlite.lua' },
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

    telescope.setup({
      defaults = defaults,
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = false,
          case_mode = 'smart_case',
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
          path_callback = vim.cmd.tcd,
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
          find_command = { 'fd', '--type', 'f', '--strip-cwd-prefix' },
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
    end)
    map('n', '<C-b>', builtin.buffers)
    -- map('n', '<C-g>', builtin.live_grep)
    map('n', '<C-s>', builtin.grep_string)
    map('n', '<LocalLeader>fd', function()
      builtin.find_files({
        prompt_title = 'Dot Files',
        cwd = '$XDG_DATA_HOME/chezmoi/',
      })
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
      builtin.resume({ cache_index = vim.v.count1 })
    end)
    map('n', '<LocalLeader>gb', builtin.git_branches)
    map('n', '<LocalLeader>gc', builtin.git_bcommits)
    map('n', '<LocalLeader>gC', builtin.git_commits)
    map('n', '<LocalLeader>gs', builtin.git_status)
    map('n', '<LocalLeader>gS', builtin.git_stash)
    map('n', '<LocalLeader>ld', builtin.lsp_document_symbols)
    map('n', '<LocalLeader>lw', builtin.lsp_workspace_symbols)
    map('n', '<LocalLeader>ls', builtin.lsp_dynamic_workspace_symbols)

    require('telescope').load_extension('fzf')
    require('telescope').load_extension('zf-native')
    require('telescope').load_extension('live_grep_args')
    vim.keymap.set('n', '<C-g>', function()
      require('telescope').extensions.live_grep_args.live_grep_args()
    end)
    require('telescope').load_extension('frecency')
    vim.keymap.set('n', '<LocalLeader><LocalLeader>', function()
      require('telescope').extensions.frecency.frecency({
        path_display = { truncate = 3 },
      })
    end)

    require('telescope').load_extension('undo')
    require('telescope').load_extension('olddirs')
    vim.keymap.set('n', '<LocalLeader>od', telescope.extensions.olddirs.picker)
    require('telescope').load_extension('lazy')
  end,
}
