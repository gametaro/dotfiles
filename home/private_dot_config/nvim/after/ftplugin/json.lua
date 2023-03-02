vim.g.lsp_start({
  cmd = { 'vscode-json-language-server', '--stdio' },
  init_options = {
    provideFormatter = true,
  },
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
})

vim.opt_local.conceallevel = 0
vim.opt_local.concealcursor = 'nc'
