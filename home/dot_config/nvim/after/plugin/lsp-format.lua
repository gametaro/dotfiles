local ok = prequire('lsp-format')
if not ok then
  return
end

require('lsp-format').setup({
  typescript = {
    exclude = { 'tsserver', 'eslint' },
  },
  lua = {
    exclude = { 'sumneko_lua' },
  },
})
