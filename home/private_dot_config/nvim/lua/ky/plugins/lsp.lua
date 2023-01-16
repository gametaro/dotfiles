return {
  {
    'williamboman/mason.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    cmd = 'Mason',
    opts = {
      ui = {
        border = vim.g.border,
      },
    },
  },
  { 'b0o/schemastore.nvim' },
  {
    'folke/neodev.nvim',
    config = function()
      require('neodev').setup({
        setup_jsonls = false,
        lspconfig = false,
      })
    end,
  },
}
