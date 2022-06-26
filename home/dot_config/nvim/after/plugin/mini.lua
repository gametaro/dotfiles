local ok = prequire('mini.pairs')
if not ok then
  return
end

require('mini.pairs').setup {
  modes = { insert = false, command = true, terminal = true },
}

vim.keymap.set(
  { 'c', 't' },
  '<C-h>',
  'v:lua.MiniPairs.bs()',
  { expr = true, desc = 'MiniPairs <BS>' }
)
