local M = {}

M.icons = {
  error = ' ',
  warn = ' ',
  hint = ' ',
  info = ' ',
}

M.border = 'single'

function M.setup(theme)
  if pcall(require, theme) then
    if theme == 'tokyonight' then
      local sidebars = {
        'NeogitStatus',
        'help',
        'packer',
        'qf',
        'terminal',
        'toggleterminal',
      }
      vim.g.tokyonight_sidebars = sidebars
      vim.cmd('colorscheme tokyonight')
    elseif theme == 'nightfox' then
      local nightfox = require('nightfox')
      nightfox.setup {
        fox = 'nightfox',
      }
      nightfox.load()
    else
      vim.cmd(string.format('colorscheme %s', theme))
    end
  end
end

return M
