local on_attach = require('ky.lsp.on_attach')
local ts = require('nvim-lsp-ts-utils')

return {
  init_options = ts.init_options,
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    ts.setup {
      update_imports_on_move = true,
      require_confirmation_on_move = true,
    }
    ts.setup_client(client)
  end,
}
