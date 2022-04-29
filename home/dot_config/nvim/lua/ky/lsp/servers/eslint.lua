local on_attach = require('ky.lsp.on_attach')

return {
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = true
    on_attach(client, bufnr)
  end,
  settings = {
    format = { enable = true },
  },
}
