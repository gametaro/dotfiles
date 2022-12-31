return {
  'RRethy/vim-illuminate',
  event = 'BufReadPost',
  config = function()
    require('illuminate').configure({
      modes_denylist = { 'i' },
      filetypes_denylist = { 'qf' },
    })
  end,
}
