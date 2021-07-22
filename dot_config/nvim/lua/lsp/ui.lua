local lsp_signature = require 'lsp_signature'
local is_nightly = require('utils').is_nightly
local icons = require('theme').icons

local M = {}

M.signs = is_nightly() and { Error = icons.error, Warn = icons.warn, Hint = icons.hint, Info = icons.info }
  or { Error = icons.error, Warning = icons.warn, Hint = icons.hint, Information = icons.info }

local function setup_signs()
  for type, icon in pairs(M.signs) do
    local hl = is_nightly() and 'DiagnosticSign' .. type or 'LspDiagnosticsSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
  end
end

-- NOTE: https://github.com/neovim/nvim-lspconfig/wiki/UI-customization
function M.on_attach()
  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
  if is_nightly() then
    vim.diagnostic.config {
      virtual_text = {
        prefix = '●',
        source = 'always', -- Or "if_many"
      },
    }
  else
    vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = {
        prefix = '●',
      },
    })
  end
end

function M.setup()
  setup_signs()
  lsp_signature.on_attach {}
end

return M
