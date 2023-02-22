vim.keymap.set('', '<Space>', '')
vim.keymap.set('', ',', '')
vim.keymap.set('n', 'ZQ', '')
vim.keymap.set('n', 'ZZ', '')
vim.keymap.set('n', 'q', '')

vim.keymap.set('n', 'Q', 'q', { desc = 'Record macro' })

vim.keymap.set('', ';', ':', { desc = 'Cmdline' })

vim.keymap.set('n', '<Leader>w', '<Cmd>write<CR>', { desc = 'Write' })
vim.keymap.set('n', '<Leader>W', '<Cmd>wall<CR>', { desc = 'Write all' })
vim.keymap.set('n', '<Leader>q', '<Cmd>quit<CR>', { desc = 'Quit' })
vim.keymap.set('n', '<Leader>Q', '<Cmd>qall<CR>', { desc = 'Quit all' })

vim.keymap.set('c', '<C-a>', '<Home>')
vim.keymap.set('c', '<C-b>', '<Left>')
vim.keymap.set('c', '<C-e>', '<End>')
vim.keymap.set('c', '<C-f>', '<Right>')
vim.keymap.set('c', '<C-n>', '<Down>')
vim.keymap.set('c', '<C-p>', '<Up>')
vim.keymap.set('c', '<M-b>', '<S-Left>')
vim.keymap.set('c', '<M-f>', '<S-right>')

vim.keymap.set('n', '<M-h>', '<C-w>h', { desc = 'Goto right widow' })
vim.keymap.set('n', '<M-j>', '<C-w>j', { desc = 'Goto Left widow' })
vim.keymap.set('n', '<M-k>', '<C-w>k', { desc = 'Goto down widow' })
vim.keymap.set('n', '<M-l>', '<C-w>l', { desc = 'Goto up widow' })
vim.keymap.set('t', '<M-h>', '<Cmd>wincmd h<CR>', { desc = 'Goto right widow' })
vim.keymap.set('t', '<M-j>', '<Cmd>wincmd j<CR>', { desc = 'Goto Left widow' })
vim.keymap.set('t', '<M-k>', '<Cmd>wincmd k<CR>', { desc = 'Goto down widow' })
vim.keymap.set('t', '<M-l>', '<Cmd>wincmd l<CR>', { desc = 'Goto up widow' })

vim.keymap.set('n', 'x', '"_x', { desc = 'Delete char' })

vim.keymap.set('c', '/', function()
  return vim.fn.getcmdtype() == '/' and [[\/]] or '/'
end, { expr = true })
vim.keymap.set('c', '?', function()
  return vim.fn.getcmdtype() == '?' and [[\?]] or '?'
end, { expr = true })
vim.keymap.set('c', '<C-x>', function()
  return vim.fn.getcmdtype() == ':' and vim.fn.expand('%:p') or ''
end, { expr = true })

vim.keymap.set('s', '<BS>', '<BS>i')
vim.keymap.set('s', '<C-h>', '<C-h>i')

vim.keymap.set('n', '<Leader>.', function()
  vim.cmd.edit('.')
end, { desc = 'Open cwd' })
vim.keymap.set('n', '-', function()
  vim.cmd.edit(vim.fn.expand('%:p:h'))
end, { desc = 'Open current directory' })
vim.keymap.set('n', '<Leader>cd', function()
  vim.cmd.tcd('%:p:h')
end, { desc = 'Change directory' })
vim.keymap.set('n', '<Leader>ud', function()
  vim.cmd.tcd('..')
end, { desc = 'Up directory' })

vim.keymap.set('n', '<Leader>i', '<Cmd>Inspect<CR>')
vim.keymap.set('n', '<Leader>I', '<Cmd>Inspect!<CR>')

vim.keymap.set(
  'n',
  'gm',
  [[<Cmd>echo repeat("\n",&cmdheight)<Bar>40messages<CR>]],
  { desc = 'Messages' }
)
vim.keymap.set('n', 'gs', [[:%s/\<<C-R><C-W>\>\C//g<left><left>]], { desc = 'Substitute word' })

vim.keymap.set({ 'n', 'x' }, 'J', 'mzJ`z', { desc = 'Join lines' })

for _, v in ipairs({ 'cc', 'dd', 'yy' }) do
  vim.keymap.set('n', v, function()
    return vim.api.nvim_get_current_line():match('^%s*$') and '"_' .. v or v
  end, { expr = true, desc = 'Smart ' .. v })
end

for _, v in ipairs({ '"', "'", '`' }) do
  vim.keymap.set({ 'x', 'o' }, v, 'i' .. v, { desc = 'Text object shortcuts' })
end
