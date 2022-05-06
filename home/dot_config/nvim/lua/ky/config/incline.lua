return function()
  require('incline').setup {
    hide = {
      focused_win = true,
      only_win = true,
    },
    ignore = {
      filetypes = { 'qf' },
    },
    window = {
      options = {
        winblend = vim.o.winblend,
      },
    },
    render = function(props)
      local fname = vim.api.nvim_buf_get_name(props.buf)
      fname = vim.fn.fnamemodify(fname, ':t')
      if fname == '' then
        fname = '[No Name]'
      end
      local extension = vim.fn.fnamemodify(fname, ':e')
      local icon, color = require('nvim-web-devicons').get_icon_color(
        fname,
        extension,
        { default = true }
      )
      local bg = string.format('#%06x', vim.api.nvim_get_hl_by_name('StatusLine', true).background)
      return {
        { icon .. ' ', guifg = color, guibg = bg },
        { fname, guibg = bg, gui = 'bold' },
      }
    end,
  }
end
