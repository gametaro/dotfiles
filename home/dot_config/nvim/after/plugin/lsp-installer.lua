local ok = prequire('nvim-lsp-installer')
if not ok then
  return
end

require('nvim-lsp-installer').setup {
  ui = {
    border = require('ky.ui').border,
  },
}
