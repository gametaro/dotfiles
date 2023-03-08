return {
  'folke/paint.nvim',
  event = 'FileType',
  config = function()
    require('paint').setup({
      highlights = {
        {
          filter = function(buf)
            return not (vim.api.nvim_buf_line_count(buf) >= vim.g.max_line_count)
          end,
          pattern = 'https?://[%w-_%.%?%.+:]+[#/%w-_%.%?%.+=&]+',
          hl = 'Underlined',
        },
      },
    })
  end,
}
