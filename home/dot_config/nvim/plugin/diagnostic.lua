local icons = require('ky.ui').icons

local diagnostic = vim.diagnostic

local signs = { Error = icons.error, Warn = icons.warn, Hint = icons.hint, Info = icons.info }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

diagnostic.config({
  severity_sort = true,
  virtual_text = false,
  -- virtual_text = {
  --   source = 'always',
  --   prefix = '●',
  --   severity = diagnostic.severity.ERROR,
  -- },
  -- virtual_lines = { only_current_line = true },
  float = {
    border = require('ky.ui').border,
    -- source = 'always',
    header = { 'Diagnostic', 'Title' },
    format = function(diag)
      return string.format('%s[%s](%s)', diag.message, diag.source, diag.code)
    end,
    prefix = function(diag, _, _)
      local level = diagnostic.severity[diag.severity]
      local prefix = string.format(' %s ', icons[string.lower(level)])
      local hiname = 'Diagnostic' .. level:sub(1, 1) .. level:sub(2):lower()
      return prefix, hiname
    end,
  },
})

vim.keymap.set('n', '<LocalLeader>e', diagnostic.open_float)
vim.keymap.set('n', '[d', diagnostic.goto_prev)
vim.keymap.set('n', ']d', diagnostic.goto_next)
vim.keymap.set('n', '<LocalLeader>dq', diagnostic.setqflist)
vim.keymap.set('n', '<LocalLeader>dl', diagnostic.setloclist)

local setlist = require('ky.defer').debounce_trailing(function()
  local qf = vim.fn.getqflist({ winid = 0, title = 0 })
  local loc = vim.fn.getloclist(0, { winid = 0, title = 0 })

  if qf and qf.winid ~= 0 and qf.title == 'Diagnostics' then
    diagnostic.setqflist({ open = false })
  end
  if loc and loc.winid ~= 0 and loc.title == 'Diagnostics' then
    diagnostic.setloclist({ open = false })
  end
end, 500)

local group = vim.api.nvim_create_augroup('mine__diagnostics', {})
vim.api.nvim_create_autocmd('DiagnosticChanged', {
  group = group,
  callback = setlist,
})

vim.api.nvim_create_autocmd('ModeChanged', {
  group = group,
  pattern = '*:s',
  callback = function(a)
    local ok, luasnip = prequire('luasnip')
    if ok and luasnip.in_snippet() then
      return diagnostic.disable(a.buf)
    end
  end,
})

vim.api.nvim_create_autocmd('ModeChanged', {
  group = group,
  pattern = '[is]:n',
  callback = function(a)
    local ok, luasnip = prequire('luasnip')
    if ok and luasnip.in_snippet() then
      return diagnostic.enable(a.buf)
    end
  end,
})
