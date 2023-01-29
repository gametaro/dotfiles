return {
  'folke/noice.nvim',
  dependencies = 'MunifTanjim/nui.nvim',
  event = 'VeryLazy',
  enabled = true,
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
        -- long_message_to_split = true,
        inc_rename = true,
      },
      -- views = {
      --   split = {
      --     enter = true,
      --   },
      -- },
      views = {
        hover = {
          border = {
            style = require('ky.ui').border,
          },
          position = { row = 2, col = 2 },
        },
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
        {
          filter = {
            event = 'lsp',
            find = 'formatting',
          },
          opts = { skip = true },
        },
      },
    })
    require('ky.abbrev').cabbrev('n', 'Noice')

    vim.keymap.set('c', '<M-CR>', function()
      require('noice').redirect(vim.fn.getcmdline())
    end, { desc = 'Redirect Cmdline' })
  end,
}
