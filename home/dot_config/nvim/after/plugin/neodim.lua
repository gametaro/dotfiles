local ok = prequire('neodim')
if not ok then return end

require('neodim').setup {
  hide = {
    virtual_text = false,
    signs = false,
    underline = false,
  },
}
