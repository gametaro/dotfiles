local ok = prequire('substitute')
if not ok then
  return
end

vim.keymap.set('n', '_', function()
  require('substitute').operator()
end)
vim.keymap.set('x', '_', function()
  require('substitute').visual()
end)
vim.keymap.set('n', 'X', function()
  require('substitute.exchange').operator()
end)
vim.keymap.set('x', 'X', function()
  require('substitute.exchange').visual()
end)
vim.keymap.set('n', 'Xc', function()
  require('substitute.exchange').cancel()
end)

require('substitute').setup({
  on_substitute = function(event)
    require('yanky').init_ring('p', event.register, event.count, event.vmode:match('[vV]'))
  end,
})
