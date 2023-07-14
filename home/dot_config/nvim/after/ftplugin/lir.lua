local win = vim.api.nvim_get_current_win()
vim.wo[win][0].signcolumn = 'no'
vim.wo[win][0].spell = false

vim.keymap.set(
  'x',
  '<Tab>',
  ':<C-u>lua require"lir.mark.actions".toggle_mark("v")<CR>',
  { buffer = true }
)
