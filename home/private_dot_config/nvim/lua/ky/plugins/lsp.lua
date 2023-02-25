return {
  { 'b0o/schemastore.nvim' },
  { 'smjonas/inc-rename.nvim', cmd = 'IncRename', config = true },
  {
    'williamboman/mason.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    cmd = 'Mason',
    opts = {
      ui = {
        border = vim.g.border,
        height = 0.8,
      },
    },
  },
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
