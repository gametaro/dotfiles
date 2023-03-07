return {
  'folke/paint.nvim',
  event = 'FileType',
  config = function()
    require('paint').setup({
      highlights = {
        {
          filter = {},
          pattern = 'https?://[%w-_%.%?%.+:]+[#/%w-_%.%?%.+=&]+',
          hl = 'Underlined',
        },
      },
    })
  end,
}
