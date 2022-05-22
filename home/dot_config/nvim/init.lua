local g = vim.g

g.mapleader = ' '
g.maplocalleader = ','

_G.prequire = function(modname)
  return pcall(require, modname)
end

pcall(function()
  require('impatient').enable_profile()
end)
require('ky.disable')
require('ky.plugins')
require('ky.colorscheme')
