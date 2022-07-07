local ok = prequire('which-key')
if not ok then return end

require('which-key').setup {
  plugins = {
    presets = {
      operators = false,
    },
    spelling = {
      enabled = true,
    },
  },
}
