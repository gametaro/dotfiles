return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
  init = function()
    vim.keymap.set('n', '<Leader>gd', '<Cmd>DiffviewOpen<CR>', { desc = 'File history' })
    vim.keymap.set(
      'n',
      '<Leader>gf',
      '<Cmd>DiffviewFileHistory %<CR>',
      { desc = 'Current file history' }
    )
    vim.keymap.set('n', '<Leader>gF', '<Cmd>DiffviewFileHistory<CR>', { desc = 'File history' })
    vim.keymap.set('x', '<Leader>gf', ":'<,'>DiffviewFileHistory<CR>", { desc = 'File history' })
  end,
  config = function()
    local win_config = {
      position = 'bottom',
    }

    local actions = require('diffview.actions')

    require('diffview').setup({
      use_icons = vim.g.nerd,
      show_help_hints = false,
      view = {
        default = {
          winbar_info = true,
        },
        file_history = {
          winbar_info = true,
        },
      },
      file_panel = {
        listing_style = 'list',
        win_config = win_config,
      },
      file_history_panel = {
        listing_style = 'list',
        win_config = win_config,
      },
      default_args = {
        DiffviewOpen = { '--untracked-files=no' },
        -- DiffviewFileHistory = { '--base=LOCAL' },
      },
      keymaps = {
        view = {
          { 'n', 'q', '<Cmd>DiffviewClose<CR>', { desc = 'Close the active Diffview' } },
          ['co'] = actions.conflict_choose('ours'),
          ['ct'] = actions.conflict_choose('theirs'),
          ['cb'] = actions.conflict_choose('base'),
          ['ca'] = actions.conflict_choose('all'),
        },
        file_panel = {
          { 'n', 'q', '<Cmd>DiffviewClose<CR>', { desc = 'Close the active Diffview' } },
        },
        file_history_panel = {
          { 'n', 'q', '<Cmd>DiffviewClose<CR>', { desc = 'Close the active Diffview' } },
        },
      },
      hooks = {
        view_opened = function()
          vim.cmd.wincmd('p')
          vim.cmd.wincmd('l')
        end,
      },
    })
  end,
}
