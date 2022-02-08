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
    elseif theme == 'kanagawa' then
      require('kanagawa').setup {
        commentStyle = 'NONE',
        keywordStyle = 'NONE',
        variablebuiltinStyle = 'NONE',
      }
      require('kanagawa').load()
    elseif theme == 'vscode' then
      vim.g.vscode_style = 'dark'
      vim.g.vscode_italic_comment = 0
      vim.cmd('colorscheme vscode')
    else
      vim.cmd(string.format('colorscheme %s', theme))
    end
  end
end

return M
