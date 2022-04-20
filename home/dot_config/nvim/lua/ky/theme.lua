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
    if theme == 'nightfox' then
      local spec = require('nightfox.spec').load('nightfox')
      require('nightfox').setup {
        options = {
          dim_inactive = true,
        },
        groups = {
          NormalFloat = { fg = spec.fg1, bg = spec.bg0 },
          FloatBorder = { fg = spec.fg3, bg = spec.bg0 },
        },
      }
      vim.cmd('colorscheme nightfox')
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
