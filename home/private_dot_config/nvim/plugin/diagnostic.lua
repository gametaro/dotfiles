local icons = require('ky.ui').icons

local signs = {
  Error = icons.diagnostic.error,
  Warn = icons.diagnostic.warn,
  Hint = icons.diagnostic.hint,
  Info = icons.diagnostic.info,
}
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
  severity_sort = true,
  virtual_text = false,
  float = {
    border = require('ky.ui').border,
    source = false,
    title = 'Diagnostic',
    title_pos = 'center',
    header = require('ky.ui').border == 'none' and { 'Diagnostic', 'Title' } or '',
    prefix = function(diag)
      local level = vim.diagnostic.severity[diag.severity]
      local prefix = string.format('%s ', icons.diagnostic[string.lower(level)])
      local hlname = 'Diagnostic' .. level:sub(1, 1) .. level:sub(2):lower()
      return prefix, hlname
    end,
    suffix = function(diag)
      local source = diag.source or ''
      local code = diag.code and string.format('(%s)', diag.code) or ''
      local suffix = string.format(' %s %s', source, code)
      return suffix, 'Comment'
    end,
  },
})

vim.keymap.set('n', '<LocalLeader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<LocalLeader>dq', vim.diagnostic.setqflist)
vim.keymap.set('n', '<LocalLeader>dl', vim.diagnostic.setloclist)

local setlist = require('ky.defer').debounce_trailing(function()
  local qf = vim.fn.getqflist({ winid = 0, title = 0 })
  local loc = vim.fn.getloclist(0, { winid = 0, title = 0 })

  if qf and qf.winid ~= 0 and qf.title == 'Diagnostics' then
    vim.diagnostic.setqflist({ open = false })
  end
  if loc and loc.winid ~= 0 and loc.title == 'Diagnostics' then
    vim.diagnostic.setloclist({ open = false })
  end
end, 500)

local group = vim.api.nvim_create_augroup('mine__diagnostics', {})
vim.api.nvim_create_autocmd('DiagnosticChanged', {
  group = group,
  callback = setlist,
})
