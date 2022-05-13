local colorscheme = 'nightfox'

local ok = pcall(require, colorscheme)
if not ok then
  return
end

if colorscheme == 'nightfox' then
  require('nightfox').setup {
    options = {
      dim_inactive = false,
    },
    groups = {
      all = {
        NormalFloat = { link = 'Normal' },
        FloatBorder = { fg = 'bg4' },
        BqfPreviewBorder = { link = 'FloatBorder' },
        IndentBlanklineContextChar = { link = 'FloatBorder' }, -- fg3
        CmpDocumentationBorder = { link = 'FloatBorder' },
        DiffText = { style = 'bold' },
        DiffDelete = { fg = 'git.removed' },
      },
    },
  }
elseif colorscheme == 'kanagawa' then
  require('kanagawa').setup {
    commentStyle = 'NONE',
    keywordStyle = 'NONE',
    variablebuiltinStyle = 'NONE',
  }
elseif colorscheme == 'vscode' then
  vim.g.vscode_style = 'dark'
  vim.g.vscode_italic_comment = 0
end

vim.api.nvim_cmd({ cmd = 'colorscheme', args = { colorscheme } }, {})
