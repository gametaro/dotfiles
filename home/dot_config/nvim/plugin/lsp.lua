local icons = require('ky.theme').icons

local lsp = vim.lsp

local float = {
  border = require('ky.theme').border,
  source = 'always',
}

local signs = { Error = icons.error, Warn = icons.warn, Hint = icons.hint, Info = icons.info }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config {
  severity_sort = true,
  virtual_text = {
    source = 'always',
    prefix = '●',
    severity = vim.diagnostic.severity.ERROR
  },
  float = float,
}

lsp.handlers['textDocument/hover'] = lsp.with(lsp.handlers.hover, float)
lsp.handlers['textDocument/signatureHelp'] = lsp.with(lsp.handlers.signature_help, float)
-- https://github.com/neovim/nvim-lspconfig/wiki/User-contributed-tips#use-nvim-notify-to-display-lsp-messages
lsp.handlers['window/showMessage'] = function(_, result, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  local level = ({
    'ERROR',
    'WARN',
    'INFO',
    'DEBUG',
  })[result.type]
  vim.notify({ result.message }, level, {
    title = 'LSP | ' .. client.name,
    timeout = 10000,
    keep = function()
      return level == 'ERROR' or level == 'WARN'
    end,
  })
end
