local ok = prequire('nvim-surround')
if not ok then
  return
end

require('nvim-surround').buffer_setup({
  surrounds = {
    ['c'] = {
      add = function()
        return {
          { '"""' },
          { '"""' },
        }
      end,
    },
  },
})
