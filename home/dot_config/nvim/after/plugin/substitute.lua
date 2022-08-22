local ok = prequire('substitute')
if not ok then
  return
end

vim.keymap.set('n', '_', require('substitute').operator)
vim.keymap.set('x', '_', require('substitute').visual)
vim.keymap.set('n', 'X', require('substitute.exchange').operator)
vim.keymap.set('x', 'X', require('substitute.exchange').visual)
vim.keymap.set('n', 'Xc', require('substitute.exchange').cancel)

require('substitute').setup({
  on_substitute = function(event)
    require('yanky').init_ring('p', event.register, event.count, event.vmode:match('[vV]'))
  end,
})
