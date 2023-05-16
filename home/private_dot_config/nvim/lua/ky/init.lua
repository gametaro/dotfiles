vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.g.nerd = true
vim.g.border = require('ky.ui').border.single
vim.g.max_line_count = 10000

require('ky.option')
require('ky.diagnostic')
require('ky.lsp')
require('ky.lazy')

vim.cmd.colorscheme('heine')
