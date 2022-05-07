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
    local hl = vim.api.nvim_get_hl_by_name('Search', true)
    local fg = string.format('#%06x', hl.foreground)
    local bg = string.format('#%06x', hl.background)
    return {
      { icon .. ' ', guifg = color, guibg = bg },
      { fname, guifg = fg, guibg = bg, gui = 'bold' },
    }
  end,
}
