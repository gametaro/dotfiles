---@param modname string
_G.prequire = function(modname)
  return pcall(require, modname)
end

require('ky')

vim.cmd.colorscheme('heine')
