vim.opt_local.spell = true
-- vim.opt_local.wrap = true
vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = 'nc'

local ok = prequire('nvim-surround')
if not ok then return end

require('nvim-surround').buffer_setup {
  surrounds = {
    ['l'] = {
      add = function()
        return {
          { '[' },
          { '](' .. vim.fn.getreg('*') .. ')' },
        }
      end,
    },
  },
}
