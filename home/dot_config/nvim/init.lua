vim.g.mapleader = ' '
vim.g.maplocalleader = ','

---@param modname string
_G.prequire = function(modname)
  return pcall(require, modname)
end

pcall(function()
  vim.cmd.packadd('impatient.nvim')
  require('impatient').enable_profile()
end)
require('ky')
