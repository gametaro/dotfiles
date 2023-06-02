return {
  'haya14busa/vim-asterisk',
  keys = {
    { '*', '<Plug>(asterisk-z*)', mode = '' },
    { '#', '<Plug>(asterisk-z#)', mode = '' },
    { 'g*', '<Plug>(asterisk-gz*)', mode = '' },
    { 'g#', '<Plug>(asterisk-gz#)', mode = '' },
  },
  init = function()
    vim.g['asterisk#keeppos'] = 1
  end,
}
