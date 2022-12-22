return {
  'folke/noice.nvim',
  dependencies = 'MunifTanjim/nui.nvim',
  config = function()
    require('noice').setup({
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
      },
      routes = {
        {
          filter = {
            event = 'msg_show',
            find = 'written',
          },
          view = 'mini',
        },
        {
          filter = {
            event = 'msg_show',
            find = '; before #',
          },
          view = 'mini',
        },
        {
          filter = {
            event = 'msg_show',
            find = '; after #',
          },
          view = 'mini',
        },
        {
          filter = {
            event = 'msg_show',
            find = '%d+L, %d+B',
          },
          view = 'mini',
        },
        {
          filter = {
            event = 'notify',
            find = 'No information available',
          },
          opts = { skip = true },
        },
      },
    })
    require('ky.abbrev').cabbrev('n', 'Noice')
  end,
}
