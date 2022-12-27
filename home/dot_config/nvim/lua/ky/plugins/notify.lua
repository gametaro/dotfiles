return {
  'rcarriga/nvim-notify',
  event = 'VeryLazy',
  config = function()
    vim.o.termguicolors = true

    require('notify').setup({
      timeout = 1000,
      render = function(bufnr, notif, highlights, config)
        local renderer = notif.title[1] == '' and 'minimal' or 'simple'
        require('notify.render')[renderer](bufnr, notif, highlights, config)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_option(win, 'wrap', true)
      end,
      stages = 'fade',
      top_down = false,
    })
  end,
}
