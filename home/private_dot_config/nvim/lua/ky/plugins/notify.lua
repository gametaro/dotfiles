return {
  'rcarriga/nvim-notify',
  event = 'VeryLazy',
  config = function()
    require('notify').setup({
      timeout = 1000,
      render = 'compact',
      on_open = function(win)
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_set_config(win, { zindex = 100 })
        end
      end,
      stages = 'fade',
      top_down = false,
      max_height = function()
        return math.floor(vim.o.lines * 0.8)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.8)
      end,
    })
  end,
}
