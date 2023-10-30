return {
  { 'b0o/schemastore.nvim' },
  { 'smjonas/inc-rename.nvim', cmd = 'IncRename', config = true },
  {
    'williamboman/mason.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    build = ':MasonUpdate',
    cmd = 'Mason',
    opts = {
      ui = {
        border = vim.g.border,
        height = 0.8,
      },
    },
  },
}
