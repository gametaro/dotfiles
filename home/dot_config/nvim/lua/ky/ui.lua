local M = {}

M.icons = {
  error = '',
  warn = '',
  hint = '',
  info = '',
}

M.border = 'single'

M.colorscheme = 'nightfox'

if pcall(require, M.colorscheme) then
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
        dim_inactive = false,
      },
      groups = {
        NormalFloat = { link = 'Normal' },
        FloatBorder = { fg = 'bg4' },
        BqfPreviewBorder = { link = 'FloatBorder' },
        IndentBlanklineContextChar = { link = 'FloatBorder' }, -- fg3
        CmpDocumentationBorder = { link = 'FloatBorder' },
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
end

return M
