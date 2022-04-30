local notify = require('notify')
local render = require('notify.render')

notify.setup {
  timeout = 1000,
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
