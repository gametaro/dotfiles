local ok = prequire('which-key')
if not ok then
  return
end

require('which-key').setup({
  plugins = {
    marks = false,
    spelling = {
      enabled = true,
    },
  },
})
