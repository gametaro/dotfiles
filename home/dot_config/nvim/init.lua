vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

pcall(require, 'impatient')
require('ky.disable')
require('ky.plugins')
require('ky.theme').setup('kanagawa')
pcall(require, 'packer_compiled')
