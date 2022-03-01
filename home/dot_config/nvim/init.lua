local g = vim.g

g.mapleader = ' '
g.maplocalleader = ','

g.do_filetype_lua = 1
g.did_load_filetypes = 0

pcall(function()
  require('impatient').enable_profile()
end)
require('ky.disable')
require('ky.plugins')
require('ky.theme').setup('nightfox')
