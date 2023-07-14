vim.lsp.start({
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

local win = vim.api.nvim_get_current_win()
vim.win[win][0].conceallevel = 0
vim.win[win][0].concealcursor = 'nc'
