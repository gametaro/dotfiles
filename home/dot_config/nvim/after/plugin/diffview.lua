local ok = prequire('diffview')
if not ok then
  return
end

local win_config = {
  position = 'bottom',
  width = 35,
  height = 12,
}

local actions = require('diffview.actions')

require('diffview').setup({
  file_panel = {
    win_config = win_config,
  },
  file_history_panel = {
    win_config = win_config,
  },
  keymaps = {
    view = {
      ['q'] = actions.close,
      ['co'] = actions.conflict_choose('ours'),
      ['ct'] = actions.conflict_choose('theirs'),
      ['cb'] = actions.conflict_choose('base'),
      ['ca'] = actions.conflict_choose('all'),
    },
    file_panel = {
      ['q'] = actions.close,
    },
    file_history_panel = {
      ['q'] = actions.close,
    },
  },
  hooks = {
    view_opened = function()
      vim.cmd.wincmd('p')
      vim.cmd.wincmd('l')
    end,
  },
})

vim.keymap.set('n', '<LocalLeader>gd', vim.cmd.DiffviewOpen)
vim.keymap.set('n', '<LocalLeader>gf', function()
  vim.cmd.DiffviewFileHistory('%')
end)
vim.keymap.set('n', '<LocalLeader>gF', vim.cmd.DiffviewFileHistory)
vim.keymap.set('x', '<LocalLeader>gf', ":'<,'>DiffviewFileHistory<CR>")

require('ky.abbrev').cabbrev('dvo', 'DiffviewOpen')
require('ky.abbrev').cabbrev('dvf', 'DiffviewFileHistory')
