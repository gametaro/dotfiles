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
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    })
  end,
}
