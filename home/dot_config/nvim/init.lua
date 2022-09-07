vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.g.ts_highlight_lua = true

---@param modname string
_G.prequire = function(modname)
  return pcall(require, modname)
end

pcall(function()
  vim.cmd.packadd('impatient.nvim')
  require('impatient').enable_profile()
end)
require('ky')
