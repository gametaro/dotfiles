local lsp_installer = require 'nvim-lsp-installer'
local ts = require 'nvim-lsp-ts-utils'
local cmp_nvim_lsp = require 'cmp_nvim_lsp'
local icons = require('ky.theme').icons

local lsp = vim.lsp

local M = {}

local float = {
  border = 'none',
}

vim.diagnostic.config {
  severity_sort = true,
  virtual_text = false,
  float = float,
}

lsp.handlers['textDocument/hover'] = lsp.with(lsp.handlers.hover, float)
lsp.handlers['textDocument/signatureHelp'] = lsp.with(lsp.handlers.signature_help, float)

local signs = { Error = icons.error, Warn = icons.warn, Hint = icons.hint, Info = icons.info }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

function M.on_attach(client, bufnr)
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { buffer = true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.keymap.set('n', 'gD', function()
    vim.lsp.buf.declaration()
  end, opts)
  vim.keymap.set('n', 'gd', function()
    vim.lsp.buf.definition()
  end, opts)
  vim.keymap.set('n', 'K', function()
    vim.lsp.buf.hover()
  end, opts)
  vim.keymap.set('n', 'gi', function()
    vim.lsp.buf.implementation()
  end, opts)
  vim.keymap.set('i', '<C-k>', function()
    vim.lsp.buf.signature_help()
  end, opts)
  vim.keymap.set('n', '<LocalLeader>la', function()
    vim.lsp.buf.add_workLeader_folder()
  end, opts)
  vim.keymap.set('n', '<LocalLeader>lr', function()
    vim.lsp.buf.remove_workLeader_folder()
  end, opts)
  vim.keymap.set('n', '<LocalLeader>ll', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)
  vim.keymap.set('n', '<LocalLeader>D', function()
    vim.lsp.buf.type_definition()
  end, opts)
  vim.keymap.set('n', '<LocalLeader>lr', function()
    vim.lsp.buf.rename()
  end, opts)
  vim.keymap.set('n', '<LocalLeader>lc', function()
    vim.lsp.buf.code_action()
  end, opts)
  vim.keymap.set('n', 'gr', function()
    vim.lsp.buf.references()
  end, opts)
  vim.keymap.set('n', '<LocalLeader>e', function()
    vim.diagnostic.open_float()
  end, opts)
  vim.keymap.set('n', '[d', function()
    vim.diagnostic.goto_prev()
  end, opts)
  vim.keymap.set('n', ']d', function()
    vim.diagnostic.goto_next()
  end, opts)
  vim.keymap.set('n', '<LocalLeader>lq', function()
    vim.diagnostic.setqflist()
  end, opts)

  if client.config.flags then
    client.config.flags.allow_incremental_sync = true
  end

  -- sometimes feel annoyed...
  -- if client.resolved_capabilities.document_highlight then
  --   vim.cmd [[
  --     augroup lsp_document_highlight
  --       autocmd! * <buffer>
  --       autocmd CursorHold,CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
  --       autocmd CursorMoved,CursorMovedI <buffer> lua vim.lsp.buf.clear_references()
  --     augroup END
  --     ]]
  -- end
  if client.resolved_capabilities.document_formatting then
    vim.keymap.set('n', '<A-f>', function()
      vim.lsp.buf.formatting()
    end, opts)
    -- vim.cmd 'autocmd mine BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()'
  elseif client.resolved_capabilities.document_range_formatting then
    vim.keymap.set('n', '<A-f>f', function()
      vim.lsp.buf.range_formatting()
    end, opts)
  end
end

function M.setup()
  lsp_installer.on_server_ready(function(server)
    local default_opts = {
      capabilities = capabilities,
      on_attach = M.on_attach,
      flags = {
        debounce_text_changes = 500,
      },
    }

    local opts = {
      ['sumneko_lua'] = function()
        local runtime_path = vim.split(package.path, ';')
        table.insert(runtime_path, 'lua/?.lua')
        table.insert(runtime_path, 'lua/?/init.lua')

        return vim.tbl_deep_extend('force', default_opts, {
          settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT',
                path = runtime_path,
              },
              diagnostics = {
                globals = { 'vim' },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file('', true),
              },
            },
          },
        })
        -- return require('lua-dev').setup {
        --   lspconfig = vim.tbl_deep_extend('force', default_opts, {
        --     settings = {
        --       Lua = {
        --         workspace = {
        --           library = vim.api.nvim_get_runtime_file('', true),
        --         },
        --       },
        --     },
        --   }),
        -- }
      end,
      ['jsonls'] = function()
        return vim.tbl_deep_extend('force', default_opts, {
          settings = {
            json = {
              schemas = require('schemastore').json.schemas(),
            },
          },
        })
      end,
      ['yamlls'] = function()
        return vim.tbl_deep_extend('force', default_opts, {
          settings = {
            yaml = {
              schemas = require('schemastore').json.schemas(),
            },
          },
        })
      end,
      ['pyright'] = function()
        return vim.tbl_deep_extend('force', default_opts, {
          settings = {
            python = {
              analysis = {
                extraPaths = {},
              },
            },
          },
        })
      end,
      ['tsserver'] = function()
        vim.tbl_deep_extend('force', default_opts, {
          on_attach = function(client, bufnr)
            M.on_attach(client, bufnr)

            client.resolved_capabilities.document_formatting = false
            client.resolved_capabilities.document_range_formatting = false

            ts.setup {
              update_imports_on_move = true,
              require_confirmation_on_move = true,
            }
            ts.setup_client(client)
          end,
        })
      end,
    }

    server:setup(opts[server.name] and opts[server.name]() or default_opts)
  end)
end

return M
