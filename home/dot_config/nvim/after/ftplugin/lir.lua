local win = vim.api.nvim_get_current_win()
vim.win[win][0].signcolumn = 'no'
vim.win[win][0].spell = false

vim.keymap.set(
  'x',
  '<Tab>',
  ':<C-u>lua require"lir.mark.actions".toggle_mark("v")<CR>',
  { buffer = true }
)
