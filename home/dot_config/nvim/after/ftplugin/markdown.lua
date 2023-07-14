local win = vim.api.nvim_get_current_win()
vim.win[win][0].spell = true
-- vim.win[win][0].wrap = true
vim.win[win][0].conceallevel = 2
vim.win[win][0].concealcursor = 'nc'

vim.lsp.start({
  cmd = { 'marksman', 'server' },
})

require('nvim-surround').buffer_setup({
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
})
