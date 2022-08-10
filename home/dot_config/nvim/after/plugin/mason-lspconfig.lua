local ok = prequire('mason-lspconfig')
if not ok then
  return
end

require('mason-lspconfig').setup({
  automatic_installation = true,
})
