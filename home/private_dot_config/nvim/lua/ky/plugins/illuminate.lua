return {
  'RRethy/vim-illuminate',
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    require('illuminate').configure({
      modes_denylist = { 'i' },
      filetypes_denylist = { 'qf' },
    })
  end,
}
