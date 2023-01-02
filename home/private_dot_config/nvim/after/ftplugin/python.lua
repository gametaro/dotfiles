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
