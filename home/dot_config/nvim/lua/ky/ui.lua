local M = {}

M.icons = {
  error = ' ',
  warn = ' ',
  hint = ' ',
  info = ' ',
}

M.border = 'single'

M.colorscheme = 'nightfox'

if
  vim.tbl_contains({
    'nightfox',
    'duskfox',
    'nordfox',
    'dayfox',
    'dawnfox',
    'terafox',
  }, M.colorscheme)
then
  require('nightfox').setup {
    options = {
      dim_inactive = true,
    },
    groups = {
      NormalFloat = { fg = 'fg1', bg = 'bg0' },
      FloatBorder = { fg = 'fg3', bg = 'bg0' },
    },
  }
elseif M.colorscheme == 'kanagawa' then
  require('kanagawa').setup {
    commentStyle = 'NONE',
    keywordStyle = 'NONE',
    variablebuiltinStyle = 'NONE',
  }
elseif M.colorscheme == 'vscode' then
  vim.g.vscode_style = 'dark'
  vim.g.vscode_italic_comment = 0
end

vim.cmd('colorscheme ' .. M.colorscheme)

return M
