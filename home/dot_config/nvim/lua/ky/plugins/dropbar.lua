return {
  'Bekaboo/dropbar.nvim',
  event = 'VeryLazy',
  keys = {
    {
      '<Leader>wp',
      function()
        require('dropbar.api').pick()
      end,
    },
  },
  config = function()
    local opts = {
      general = {
        update_events = {
          win = {
            -- 'CursorMoved',
            -- 'CursorMovedI',
            'WinEnter',
            'WinLeave',
            -- 'WinResized',
            -- 'WinScrolled',
          },
          global = {
            'DirChanged',
            -- 'VimResized',
          },
        },
      },
      bar = {
        sources = function(_, _)
          local sources = require('dropbar.sources')
          return {
            sources.path,
            {
              get_symbols = function(buf, win, cursor)
                if vim.bo[buf].ft == 'markdown' then
                  return sources.markdown.get_symbols(buf, win, cursor)
                end
                -- for _, source in ipairs({
                --   sources.lsp,
                --   sources.treesitter,
                -- }) do
                --   local symbols = source.get_symbols(buf, win, cursor)
                --   if not vim.tbl_isempty(symbols) then
                --     return symbols
                --   end
                -- end
                return {}
              end,
            },
          }
        end,
      },
      sources = {
        path = {
          modified = function(sym)
            return sym:merge({
              name = sym.name,
              icon = ' ',
              name_hl = 'DiffAdded',
              icon_hl = 'DiffAdded',
            })
          end,
        },
      },
    }
    require('dropbar').setup(opts)
  end,
}
