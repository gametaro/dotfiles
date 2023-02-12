return {
  'folke/noice.nvim',
  dependencies = 'MunifTanjim/nui.nvim',
  event = 'VeryLazy',
  enabled = true,
  config = function()
    local function help(subject)
      local win = vim.api.nvim_get_current_win()
      if vim.api.nvim_win_get_config(win).relative ~= '' then
        vim.api.nvim_win_close(win, true)
      end

      vim.cmd.help(subject)
    end

    require('noice').setup({
      lsp = {
        -- documentation = {
        --   opts = {
        --     border = { style = vim.g.border, padding = { row = 0 } },
        --     position = { row = 2 },
        --   },
        -- },
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      markdown = {
        hover = {
          ['|(%S-)|'] = help,
          ['`:(%S-)`'] = help,
          ["'(%S-)'"] = help,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        -- long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = false,
      },
      -- views = {
      --   split = {
      --     enter = true,
      --   },
      -- },
      -- views = {
      --   hover = {
      --     border = {
      --       style = vim.g.border,
      --       padding = { col = 3 },
      --     },
      --     position = { row = 2, col = 1 },
      --   },
      -- },
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
    -- require('ky.abbrev').cabbrev('n', 'Noice')

    vim.keymap.set('c', '<M-CR>', function()
      require('noice').redirect(vim.fn.getcmdline())
    end, { desc = 'Redirect Cmdline' })
  end,
}
