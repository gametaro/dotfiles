local win = vim.api.nvim_get_current_win()
vim.wo[win][0].spell = true
-- vim.wo[win][0].wrap = true
vim.wo[win][0].conceallevel = 2
vim.wo[win][0].concealcursor = 'nc'

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
