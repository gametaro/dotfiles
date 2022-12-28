return {
  'haya14busa/vim-asterisk',
  keys = {
    { '*', mode = '' },
    { '#', mode = '' },
    { 'g*', mode = '' },
    { 'g#', mode = '' },
  },
  config = function()
    vim.g['asterisk#keeppos'] = 1
    vim.keymap.set('', '*', '<Plug>(asterisk-z*)')
    vim.keymap.set('', '#', '<Plug>(asterisk-z#)')
    vim.keymap.set('', 'g*', '<Plug>(asterisk-gz*)')
    vim.keymap.set('', 'g#', '<Plug>(asterisk-gz#)')
  end,
}
