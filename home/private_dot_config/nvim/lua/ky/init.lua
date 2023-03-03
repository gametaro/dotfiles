local profile = vim.env.NVIM_PROFILE
if profile then
  local profilepath = vim.fn.stdpath('data') .. '/lazy/profile.nvim'
  vim.opt.runtimepath:prepend(profilepath)
  local ok, prof = pcall(require, 'profile')
  if ok then
    prof.instrument_autocmds()
    if profile:lower():match('^start') then
      prof.start('*')
    else
      prof.instrument('*')
    end
  end
  vim.opt.runtimepath:remove(profilepath)
end

vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.g.nerd = false
vim.g.border = require('ky.ui').border.single
vim.g.max_line_count = 10000

require('ky.option')
require('ky.diagnostic')
require('ky.lsp')
require('ky.lazy')

vim.cmd.colorscheme('heine')
