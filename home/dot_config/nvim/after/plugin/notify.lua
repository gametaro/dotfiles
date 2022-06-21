local ok = prequire('notify')
if not ok then
  return
end

local notify = require('notify')
local render = require('notify.render')

notify.setup {
  timeout = 1000,
  on_open = function(win)
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_set_config(win, { border = require('ky.ui').border })
    end
  end,
  render = function(bufnr, notif, highlights, config)
    local renderer = notif.title[1] == '' and 'minimal' or 'default'
    -- notif.keep = function()
    --   return notif.level == 'ERROR'
    -- end

    render[renderer](bufnr, notif, highlights, config)
  end,
}

vim.notify = notify

vim.keymap.set('n', 'gn', '<Cmd>Notifications<CR>')
