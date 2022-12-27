vim.opt_local.signcolumn = 'no'
vim.opt_local.spell = false

vim.keymap.set(
  'x',
  '<Tab>',
  ':<C-u>lua require"lir.mark.actions".toggle_mark("v")<CR>',
  { buffer = true }
)
