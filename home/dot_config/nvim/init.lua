pcall(require, 'impatient')

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

require 'ky.disable'
require 'ky.plugins'
require('ky.theme').setup 'nightfox'
pcall(require, 'packer_compiled')
