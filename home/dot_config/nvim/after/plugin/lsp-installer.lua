local ok = prequire('nvim-lsp-installer')
if not ok then
  return
end

require('nvim-lsp-installer').setup {
  ensure_installed = {
    'bashls',
    'cssls',
    'dockerls',
    'eslint',
    'graphql',
    'html',
    'jsonls',
    'sumneko_lua',
    'tsserver',
    'yamlls',
  },
  ui = {
    border = require('ky.ui').border,
  },
}
