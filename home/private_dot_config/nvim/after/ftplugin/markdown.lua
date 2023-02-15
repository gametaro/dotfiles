vim.opt_local.spell = true
-- vim.opt_local.wrap = true
vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = 'nc'

vim.g.lsp_start({
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
