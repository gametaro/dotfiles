local ok = prequire('nvim-lsp-installer')
if not ok then
  return
end

require('nvim-lsp-installer').setup {
  ensure_installed = require('ky.utils').headless and {} or {
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
    'marksman',
  },
  ui = {
    border = require('ky.ui').border,
  },
}

require('ky.abbrev').cabbrev('lii', 'LspInstallInfo')
