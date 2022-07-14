local ok = prequire('nvim-surround')
if not ok then return end

require('nvim-surround').buffer_setup {
  delimiters = {
    pairs = {
      ['f'] = function()
        return {
          'function '
            .. require('nvim-surround.utils').get_input('Enter the function name: ')
            .. '(',
          ')',
        }
      end,
    },
  },
}
