local lsp_installer = require 'nvim-lsp-installer'
local ts = require 'nvim-lsp-ts-utils'
local cmp_nvim_lsp = require 'cmp_nvim_lsp'
local icons = require('theme').icons

local lsp = vim.lsp

local M = {}

local float = {
  border = 'single',
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
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

function M.on_attach(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  local opts = { noremap = true, silent = true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('i', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<Leader>wa', '<Cmd>lua vim.lsp.buf.add_workLeader_folder()<CR>', opts)
  buf_set_keymap('n', '<Leader>wr', '<Cmd>lua vim.lsp.buf.remove_workLeader_folder()<CR>', opts)
  buf_set_keymap('n', '<Leader>wl', '<Cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<Leader>D', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<Leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<Leader>ca', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<Leader>e', '<Cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<Cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<Cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<Leader>lq', '<Cmd> lua vim.diagnostic.setqflist()<CR>', opts)

  if client.config.flags then
    client.config.flags.allow_incremental_sync = true
  end

  if client.resolved_capabilities.document_highlight then
    vim.cmd [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold,CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved,CursorMovedI <buffer> lua vim.lsp.buf.clear_references()
      augroup END
      ]]
  end

  if client.resolved_capabilities.document_formatting then
    buf_set_keymap('n', '<A-f>', '<Cmd>lua vim.lsp.buf.formatting_sync()<CR>', opts)
    vim.cmd 'autocmd mine BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()'
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap('n', '<A-f>f', '<Cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
  end
end

function M.setup()
  lsp_installer.on_server_ready(function(server)
    local default_opts = {
      capabilities = capabilities,
      on_attach = M.on_attach,
      flags = {
        debounce_text_changes = 150,
      },
    }

    local opts = {
      ['sumneko_lua'] = function()
        return require('lua-dev').setup {
          lspconfig = default_opts,
        }
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
