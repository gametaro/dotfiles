local icons = require('ky.ui').icons

local signs = { Error = icons.error, Warn = icons.warn, Hint = icons.hint, Info = icons.info }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config {
  severity_sort = true,
  virtual_text = false,
  -- virtual_text = {
  --   source = 'always',
  --   prefix = '●',
  --   severity = vim.diagnostic.severity.ERROR,
  -- },
  float = {
    border = require('ky.ui').border,
    -- source = 'always',
    header = { 'Diagnostic', 'Title' },
    format = function(diag)
      return string.format('%s %s(%s)', diag.message, diag.source, diag.code)
    end,
    prefix = function(diag, _, _)
      local level = diagnostic.severity[diag.severity]
      local prefix = string.format(' %s ', icons[string.lower(level)])
      local hiname = 'Diagnostic' .. level:sub(1, 1) .. level:sub(2):lower()
      return prefix, hiname
    end,
  },
}

vim.keymap.set('n', '<LocalLeader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<LocalLeader>dq', vim.diagnostic.setqflist)
vim.keymap.set('n', '<LocalLeader>dl', vim.diagnostic.setloclist)
