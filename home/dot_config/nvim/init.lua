local g = vim.g

g.mapleader = ' '
g.maplocalleader = ','

_G.prequire = function(modname)
  return pcall(require, modname)
end

pcall(function()
  vim.cmd('packadd impatient.nvim')
  require('impatient').enable_profile()
end)
require('ky')
