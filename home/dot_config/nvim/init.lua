vim.g.mapleader = ' '
vim.g.maplocalleader = ','

require 'ky.disable'
pcall(require, 'impatient')
vim.defer_fn(function()
  require('ky.plugins')
end, 0)
require('ky.theme').setup 'nightfox'
