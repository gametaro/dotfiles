local notify = require('notify')
local render = require('notify.render')

notify.setup {
  timeout = 1000,
  on_open = function(win)
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_set_config(win, { border = require('ky.ui').border })
    end
  end,
  render = function(bufnr, notif, highlights)
    local renderer = notif.title[1] == '' and 'minimal' or 'default'
    notif.keep = function()
      return notif.level == 'ERROR' or notif.level == 'WARN'
    end

    render[renderer](bufnr, notif, highlights)
  end,
}

vim.notify = notify

require('telescope').load_extension('notify')
