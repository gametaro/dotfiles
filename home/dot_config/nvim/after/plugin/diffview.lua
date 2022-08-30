vim.api.nvim_create_autocmd('User', {
  pattern = 'JetpackDiffviewNvimPost',
  callback = function()
    local win_config = {
      position = 'bottom',
      width = 35,
      height = 12,
    }

    require('diffview').setup({
      file_panel = {
        win_config = win_config,
      },
      file_history_panel = {
        win_config = win_config,
      },
      keymaps = {
        view = {
          ['q'] = vim.cmd.DiffviewClose,
        },
        file_panel = {
          ['q'] = vim.cmd.DiffviewClose,
        },
        file_history_panel = {
          ['q'] = vim.cmd.DiffviewClose,
        },
      },
      hooks = {
        diff_buf_read = function()
          vim.opt_local.list = false
          vim.opt_local.winbar = nil
        end,
        view_opened = function()
          vim.cmd.wincmd('p')
        end,
      },
    })
  end,
})

vim.keymap.set('n', '<LocalLeader>gd', vim.cmd.DiffviewOpen)
vim.keymap.set('n', '<LocalLeader>gf', function()
  vim.cmd.DiffviewFileHistory('%')
end)
vim.keymap.set('n', '<LocalLeader>gF', vim.cmd.DiffviewFileHistory)
vim.keymap.set('x', '<LocalLeader>gf', ":'<,'>DiffviewFileHistory<CR>")

require('ky.abbrev').cabbrev('dvo', 'DiffviewOpen')
require('ky.abbrev').cabbrev('dvf', 'DiffviewFileHistory')
