local lsp_config = require('lspconfig')
local lsp_installer = require('nvim-lsp-installer')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local on_attach = require('ky.lsp.on_attach')

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

local default_config = {
  capabilities = capabilities,
  on_attach = on_attach,
}

lsp_installer.setup {}

for _, server in ipairs(lsp_installer.get_installed_servers()) do
  local ok, config = prequire('ky.lsp.servers.' .. server.name)
  config = ok and vim.tbl_deep_extend('force', default_config, config) or default_config
  lsp_config[server.name].setup(config)
end
