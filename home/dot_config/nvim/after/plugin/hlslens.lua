local ok = prequire('hlslens')
if not ok then
  return
end

vim.keymap.set(
  'n',
  'n',
  [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]]
)
vim.keymap.set(
  'n',
  'N',
  [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]]
)
vim.keymap.set('', '*', '<Plug>(asterisk-z*)<Cmd>lua require("hlslens").start()<CR>')
vim.keymap.set('', '#', '<Plug>(asterisk-z#)<Cmd>lua require("hlslens").start()<CR>')
vim.keymap.set('', 'g*', '<Plug>(asterisk-gz*)<Cmd>lua require("hlslens").start()<CR>')
vim.keymap.set('', 'g#', '<Plug>(asterisk-gz#)<Cmd>lua require("hlslens").start()<CR>')

require('hlslens').setup({ calm_down = true })
