local ok = prequire('marks')
if not ok then return end

require('marks').setup {
  default_mappings = false,
  builtin_marks = { '.', '<', '>', '^', "'", '"', '[', ']' },
}
