vim.opt_local.isfname:append('@-@')

local ok = prequire('nvim-surround')
if not ok then return end

require('nvim-surround').buffer_setup {
  surrounds = {
    ['$'] = {
      add = function()
        return {
          { '${' },
          { '}' },
        }
      end,
    },
  },
}
