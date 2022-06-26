local ok = prequire('mini.pairs')
if not ok then
  return
end

require('mini.pairs').setup {
  modes = { insert = false, command = true, terminal = true },
}
