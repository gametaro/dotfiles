return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
  init = function()
    vim.keymap.set('n', '<LocalLeader>gd', vim.cmd.DiffviewOpen)
    vim.keymap.set('n', '<LocalLeader>gf', function()
      vim.cmd.DiffviewFileHistory('%')
    end)
    vim.keymap.set('n', '<LocalLeader>gF', vim.cmd.DiffviewFileHistory)
    vim.keymap.set('x', '<LocalLeader>gf', ":'<,'>DiffviewFileHistory<CR>")
  end,
  config = function()
    local win_config = {
      position = 'bottom',
      height = 12,
    }

    local actions = require('diffview.actions')

    require('diffview').setup({
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
        DiffviewOpen = { '--untracked-files=no', '--imply-local' },
        DiffviewFileHistory = { '--base=LOCAL' },
      },
      keymaps = {
        view = {
          ['q'] = vim.cmd.DiffviewClose,
          ['co'] = actions.conflict_choose('ours'),
          ['ct'] = actions.conflict_choose('theirs'),
          ['cb'] = actions.conflict_choose('base'),
          ['ca'] = actions.conflict_choose('all'),
        },
        file_panel = {
          ['q'] = vim.cmd.DiffviewClose,
        },
        file_history_panel = {
          ['q'] = vim.cmd.DiffviewClose,
        },
      },
      hooks = {
        view_opened = function()
          vim.cmd.wincmd('p')
          vim.cmd.wincmd('l')
        end,
      },
    })

    require('ky.abbrev').cabbrev('dvo', 'DiffviewOpen')
    require('ky.abbrev').cabbrev('dvf', 'DiffviewFileHistory')
  end,
}
