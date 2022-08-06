local ok = prequire('nvim-surround')
if not ok then return end

require('nvim-surround').buffer_setup {
  surrounds = {
    ['f'] = {
      add = function()
        local result = require('nvim-surround.config').get_input('Enter the function name: ')
        if result then return { { result .. '(' }, { ')' } } end
      end,
    },
    ['F'] = {
      add = function()
        return { { 'function() ' }, { ' end' } }
      end,
    },
  },
}
