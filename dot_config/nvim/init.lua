if pcall(require, 'impatient') then
  require('impatient')
end
require 'options'
require 'utils'
require 'keymaps'
require 'autocmd'
require('plugins').setup()
require('theme').setup 'nightfox'
require 'packer_compiled'
