local ok = prequire('notify')
if not ok then return end

local notify = require('notify')
local render = require('notify.render')
local stages_util = require('notify.stages.util')

notify.setup {
  timeout = 1000,
  render = function(bufnr, notif, highlights, config)
    local renderer = notif.title[1] == '' and 'minimal' or 'default'
    render[renderer](bufnr, notif, highlights, config)
  end,
  on_open = function(win)
    vim.api.nvim_win_set_option(win, 'wrap', true)
  end,
  -- based on built-in `fade`
  stages = {
    function(state)
      local next_height = state.message.height + 2
      local next_row =
        stages_util.available_slot(state.open_windows, next_height, stages_util.DIRECTION.BOTTOM_UP)
      if not next_row then return nil end
      return {
        relative = 'editor',
        anchor = 'NE',
        width = state.message.width,
        height = state.message.height,
        col = vim.opt.columns:get(),
        row = next_row,
        border = 'rounded',
        style = 'minimal',
        opacity = 0,
      }
    end,
    function()
      return {
        opacity = { 100 },
        col = { vim.o.columns },
      }
    end,
    function()
      return {
        col = { vim.o.columns },
        time = true,
      }
    end,
    function()
      return {
        opacity = {
          0,
          frequency = 2,
          complete = function(cur_opacity)
            return cur_opacity <= 4
          end,
        },
        col = { vim.o.columns },
      }
    end,
  },
}

vim.notify = notify

vim.keymap.set('n', 'gn', '<Cmd>Notifications<CR>')
