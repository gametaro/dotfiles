local lsp_installer = require('nvim-lsp-installer')
local ts = require('nvim-lsp-ts-utils')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local icons = require('ky.theme').icons

local lsp = vim.lsp

local M = {}

local float = {
  border = require('ky.theme').border,
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
  local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  map('n', 'gD', vim.lsp.buf.declaration)
  map('n', 'gd', vim.lsp.buf.definition)
  map('n', 'K', vim.lsp.buf.hover)
  map('n', 'gi', vim.lsp.buf.implementation)
  map('i', '<C-s>', vim.lsp.buf.signature_help)
  map('n', '<LocalLeader>la', vim.lsp.buf.add_workspace_folder)
  map('n', '<LocalLeader>lr', vim.lsp.buf.remove_workspace_folder)
  map('n', '<LocalLeader>ll', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end)
  map('n', '<LocalLeader>D', vim.lsp.buf.type_definition)
  map('n', '<LocalLeader>lr', vim.lsp.buf.rename)
  map('n', '<LocalLeader>lc', vim.lsp.buf.code_action)
  map('n', 'gr', vim.lsp.buf.references)
  map('n', '<LocalLeader>e', vim.diagnostic.open_float)
  map('n', '[d', vim.diagnostic.goto_prev)
  map('n', ']d', vim.diagnostic.goto_next)
  map('n', '<LocalLeader>lq', vim.diagnostic.setqflist)

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
    vim.keymap.set('n', '<A-f>', vim.lsp.buf.formatting)
    -- vim.cmd 'autocmd mine BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()'
  elseif client.resolved_capabilities.document_range_formatting then
    vim.keymap.set('n', '<A-f>f', vim.lsp.buf.range_formatting)
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
              -- for cloudformation
              -- see https://github.com/aws-cloudformation/cfn-lint-visual-studio-code/issues/69
              customTags = {
                '!And',
                '!And sequence',
                '!If',
                '!If sequence',
                '!Not',
                '!Not sequence',
                '!Equals',
                '!Equals sequence',
                '!Or',
                '!Or sequence',
                '!FindInMap',
                '!FindInMap sequence',
                '!Base64',
                '!Join',
                '!Join sequence',
                '!Cidr',
                '!Ref',
                '!Sub',
                '!Sub sequence',
                '!GetAtt',
                '!GetAZs',
                '!ImportValue',
                '!ImportValue sequence',
                '!Select',
                '!Select sequence',
                '!Split',
                '!Split sequence',
              },
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
