return {
  'RRethy/vim-illuminate',
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    require('illuminate').configure({
      modes_denylist = { 'i' },
      filetypes_denylist = { 'qf' },
      large_file_cutoff = vim.g.max_line_count,
    })
  end,
}
