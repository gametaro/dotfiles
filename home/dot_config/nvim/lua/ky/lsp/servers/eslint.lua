local on_attach = require('ky.lsp.on_attach')

return {
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = true
    on_attach(client, bufnr)
  end,
  settings = {
    format = { enable = true },
  },
}
