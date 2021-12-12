pcall(require, 'impatient')
require 'options'
require 'utils'
require 'keymaps'
require 'autocmd'
require('plugins').setup()
require('theme').setup 'nightfox'
pcall(require, 'packer_compiled')
