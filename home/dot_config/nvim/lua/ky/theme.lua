local M = {}

M.icons = {
  error = ' ',
  warn = ' ',
  hint = ' ',
  info = ' ',
}

function M.setup(theme)
  if pcall(require, theme) then
    local sidebars = {
      'NeogitStatus',
      'help',
      'packer',
      'qf',
      'terminal',
      'toggleterminal',
    }

    if theme == 'tokyonight' then
      vim.g.tokyonight_sidebars = sidebars
      vim.cmd(string.format('colorscheme %s', theme))
    elseif theme == 'nightfox' then
      require('nightfox').load()
    end
  end
end

return M
