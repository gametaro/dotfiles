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
      key_bindings = {
        view = {
          ['q'] = '<Cmd>DiffviewClose<CR>',
        },
        file_panel = {
          ['q'] = '<Cmd>DiffviewClose<CR>',
        },
        file_history_panel = {
          ['q'] = '<Cmd>DiffviewClose<CR>',
        },
      },
      hooks = {
        diff_buf_read = function()
          vim.opt_local.list = false
          vim.go.winbar = nil
        end,
        view_opened = function()
          vim.cmd.wincmd('p')
        end,
      },
    })
  end,
})

vim.keymap.set('n', '<LocalLeader>gd', '<Cmd>DiffviewOpen<CR>')
vim.keymap.set('n', '<LocalLeader>gf', '<Cmd>DiffviewFileHistory %<CR>')
vim.keymap.set('n', '<LocalLeader>gF', '<Cmd>DiffviewFileHistory<CR>')
vim.keymap.set('x', '<LocalLeader>gf', ":'<,'>DiffviewFileHistory<CR>")

require('ky.abbrev').cabbrev('dvo', 'DiffviewOpen')
require('ky.abbrev').cabbrev('dvf', 'DiffviewFileHistory')
