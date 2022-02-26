vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

pcall(function()
  require('impatient').enable_profile()
end)
require('ky.disable')
require('ky.plugins')
require('ky.theme').setup('nightfox')
