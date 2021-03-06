local colorscheme = 'heine'

local ok = prequire(colorscheme)
if not ok then return end

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
        CmpItemAbbrMatch = { style = 'bold' },
        CmpItemAbbrMatchFuzzy = { style = 'bold' },
        TelescopeMatching = { link = 'CmpItemAbbrMatch' },
        DiffText = { style = 'bold' },
        DiffDelete = { fg = 'syntax.comment' },
      },
    },
  }
  colorscheme = 'terafox'
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

vim.cmd.colorscheme(colorscheme)
