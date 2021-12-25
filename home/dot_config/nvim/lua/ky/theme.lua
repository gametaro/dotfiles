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
      local nightfox = require 'nightfox'
      nightfox.setup {
        fox = 'duskfox',
        hlgroups = {
          TSVariable = { fg = '${fg_alt}' },
          TelescopeNormal = { bg = '${bg_float}' },
          TelescopePromptBorder = { fg = '#35334f', bg = '#35334f' },
          TelescopeResultsBorder = { fg = '${bg_float}', bg = '${bg_float}' },
          TelescopePreviewBorder = { fg = '${bg_float}', bg = '${bg_float}' },
          TelescopePromptNormal = { bg = '#35334f' },
          TelescopeResultsTitle = { fg = '${bg_float}', bg = '${bg_float}' },
          TelescopePreviewTitle = { fg = '${bg_float}', bg = '${bg_float}' },
        },
      }
      nightfox.load()
    end
  end
end

return M
