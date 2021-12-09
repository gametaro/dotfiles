local icons = require('theme').icons

local M = {}

M.signs = { Error = icons.error, Warn = icons.warn, Hint = icons.hint, Info = icons.info }

local function setup_signs()
  for type, icon in pairs(M.signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
  end
end

-- NOTE: https://github.com/neovim/nvim-lspconfig/wiki/UI-customization
function M.on_attach()
  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
  vim.diagnostic.config {
    severity_sort = true,
    virtual_text = {
      prefix = '●',
      source = 'always',
    },
  }
end

function M.setup()
  setup_signs()
end

return M
