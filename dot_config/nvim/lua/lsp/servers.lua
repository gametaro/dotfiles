local null_ls = require 'lsp.null-ls'

local M = {}

local function on_attach(client, bufnr)
  require('lsp.ui').on_attach()
  require('lsp.format').setup(client, bufnr)
  require('lsp.highlight').setup(client)
  require('lsp.keymap').setup(bufnr)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local function ensure_servers_installed()
  local lsp_installer_servers = require 'nvim-lsp-installer.servers'

  local servers = { 'sumneko_lua', 'tsserver', 'jsonls', 'bashls', 'eslint', 'yamlls' }
  for _, server in pairs(servers) do
    local ok, s = lsp_installer_servers.get_server(server)
    if ok then
      if not s:is_installed() then
        s:install()
      end
    end
  end
end

function M.setup()
  null_ls.setup(on_attach)

  local lsp_installer = require 'nvim-lsp-installer'
  -- ensure_servers_installed()

  lsp_installer.on_server_ready(function(server)
    local config = {
      capabilities = capabilities,
      on_attach = on_attach,
      flags = {
        debounce_text_changes = 500,
      },
    }

    if server.name == 'sumneko_lua' then
      config = require('lua-dev').setup {
        lspconfig = {
          on_attach = on_attach,
          flags = {
            debounce_text_changes = 500,
          },
        },
      }
    end

    if server.name == 'tsserver' then
      config.on_attach = function(client, bufnr)
        require('lsp.keymap').setup(bufnr)
        require('lsp.ui').on_attach()
        require('lsp.highlight').setup(client)

        if client.config.flags then
          client.config.flags.allow_incremental_sync = true
        end
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false

        local ts = require 'nvim-lsp-ts-utils'
        ts.setup {}
        ts.setup_client(client)
      end
    end

    if server.name == 'jsonls' then
      config.settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
        },
      }
    end

    server:setup(config)
  end)
end

return M
