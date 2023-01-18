return {
  'rcarriga/nvim-notify',
  event = 'VeryLazy',
  config = function()
    require('notify').setup({
      timeout = 1000,
      render = 'compact',
      on_open = function(win)
        vim.api.nvim_win_set_option(win, 'wrap', true)
      end,
      stages = 'fade',
      top_down = false,
    })
  end,
}
