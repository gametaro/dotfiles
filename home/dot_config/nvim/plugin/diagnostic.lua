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
    source = 'always',
  },
}

vim.keymap.set('n', '<LocalLeader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<LocalLeader>dq', vim.diagnostic.setqflist)
vim.keymap.set('n', '<LocalLeader>dl', vim.diagnostic.setloclist)
