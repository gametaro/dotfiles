local ok = prequire('neogen')
if not ok then
  return
end

require('neogen').setup({ snippet_engine = 'luasnip' })
vim.keymap.set('n', '<LocalLeader>nf', require('neogen').generate)
