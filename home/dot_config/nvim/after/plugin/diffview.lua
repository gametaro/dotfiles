local ok = prequire('diffview')
if not ok then
  return
end

vim.keymap.set('n', '<LocalLeader>gd', '<Cmd>DiffviewOpen<CR>')
vim.keymap.set('n', '<LocalLeader>gf', '<Cmd>DiffviewFileHistory<CR>')

local win_config = {
  position = 'bottom',
  width = 35,
  height = 12,
}

require('diffview').setup {
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
    end,
    view_opened = function()
      vim.cmd('wincmd p')
    end,
  },
}
