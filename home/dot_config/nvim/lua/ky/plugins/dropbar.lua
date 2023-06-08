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
      bar = {
        sources = function(_, _)
          local sources = require('dropbar.sources')
          return {
            sources.path,
            {
              get_symbols = function(buf, cursor)
                if vim.bo[buf].ft == 'markdown' then
                  return sources.markdown.get_symbols(buf, cursor)
                end
                -- for _, source in ipairs({
                --   sources.lsp,
                --   sources.treesitter,
                -- }) do
                --   local symbols = source.get_symbols(buf, cursor)
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
    }
    require('dropbar').setup(opts)
  end,
}
