vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.g.nerd = false
vim.g.border = require('ky.ui').border.single

require('ky.option')
require('ky.diagnostic')
require('ky.lsp')
require('ky.lazy')

vim.cmd.colorscheme('heine')
