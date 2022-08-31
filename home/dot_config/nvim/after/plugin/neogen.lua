local ok = prequire('neogen')
if not ok then
  return
end

local neogen = require('neogen')
neogen.setup({ snippet_engine = 'luasnip' })
vim.keymap.set('n', '<LocalLeader>nf', function()
  neogen.generate()
end)
vim.keymap.set('n', '<LocalLeader>nt', function()
  neogen.generate({ type = 'type' })
end)
vim.keymap.set('n', '<LocalLeader>nc', function()
  neogen.generate({ type = 'class' })
end)
vim.keymap.set('n', '<LocalLeader>nF', function()
  neogen.generate({ type = 'file' })
end)
