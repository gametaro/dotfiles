vim.g.mapleader = ' '
vim.g.maplocalleader = ','

require 'ky.disable'
pcall(require, 'impatient')
require 'ky.plugins'
require('ky.theme').setup 'nightfox'
