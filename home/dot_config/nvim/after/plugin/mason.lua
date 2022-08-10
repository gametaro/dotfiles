local ok = prequire('mason')
if not ok then
  return
end

require('mason').setup({
  ui = {
    border = require('ky.ui').border,
  },
})
