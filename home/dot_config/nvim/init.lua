local g = vim.g

g.mapleader = ' '
g.maplocalleader = ','

pcall(function()
  require('impatient').enable_profile()
end)
require('ky.disable')
require('ky.plugins')
require('ky.colorscheme')
