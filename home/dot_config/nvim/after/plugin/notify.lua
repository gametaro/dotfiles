local ok = prequire('notify')
if not ok then
  return
end

local notify = require('notify')
local render = require('notify.render')

notify.setup({
  timeout = 1000,
  render = function(bufnr, notif, highlights, config)
    local renderer = notif.title[1] == '' and 'minimal' or 'simple'
    render[renderer](bufnr, notif, highlights, config)
  end,
  on_open = function(win)
    vim.api.nvim_win_set_option(win, 'wrap', true)
  end,
  top_down = false,
})

vim.notify = notify

vim.keymap.set('n', 'gn', '<Cmd>Notifications<CR>')
