vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.g.nerd = false
vim.g.border = require('ky.ui').border.single
vim.g.max_line_count = 10000

require('ky.option')
require('ky.diagnostic')
require('ky.lsp')
require('ky.lazy')

local profile = vim.env.NVIM_PROFILE
if profile then
  require('profile').instrument_autocmds()
  if profile:lower():match('^start') then
    require('profile').start('*')
  else
    require('profile').instrument('*')
  end
end

vim.cmd.colorscheme('heine')
