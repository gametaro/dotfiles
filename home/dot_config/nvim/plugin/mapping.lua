vim.keymap.set('', '<Space>', '')
vim.keymap.set('', ',', '')

vim.keymap.set('n', 'ZQ', '<Cmd>qall!<CR>')
vim.keymap.set('n', 'ZZ', '<Cmd>xall<CR>')

vim.keymap.set('n', 'q', '')

vim.keymap.set('n', 'Q', 'q', { desc = 'Record macro' })

vim.keymap.set('', ';', ':', { desc = 'Cmdline' })

vim.keymap.set('n', '<Leader>w', '<Cmd>write<CR>', { desc = 'Write' })
vim.keymap.set('n', '<Leader>W', '<Cmd>wall<CR>', { desc = 'Write all' })
vim.keymap.set('n', '<Leader>q', '<Cmd>quit<CR>', { desc = 'Quit' })
vim.keymap.set('n', '<Leader>Q', '<Cmd>qall<CR>', { desc = 'Quit all' })

vim.keymap.set('n', '<Leader>i', '<Cmd>Inspect<CR>')
vim.keymap.set('n', '<Leader>I', '<Cmd>Inspect!<CR>')
vim.keymap.set('n', '<Leader>T', '<Cmd>InspectTree<CR>')

vim.keymap.set('c', '<C-a>', '<Home>')
vim.keymap.set('c', '<C-b>', '<Left>')
vim.keymap.set('c', '<C-e>', '<End>')
vim.keymap.set('c', '<C-f>', '<Right>')
vim.keymap.set('c', '<C-n>', '<Down>')
vim.keymap.set('c', '<C-p>', '<Up>')
vim.keymap.set('c', '<M-b>', '<S-Left>')
vim.keymap.set('c', '<M-f>', '<S-right>')

vim.keymap.set('n', '<M-h>', '<C-w>h', { desc = 'Goto right window' })
vim.keymap.set('n', '<M-j>', '<C-w>j', { desc = 'Goto left window' })
vim.keymap.set('n', '<M-k>', '<C-w>k', { desc = 'Goto down window' })
vim.keymap.set('n', '<M-l>', '<C-w>l', { desc = 'Goto up window' })
vim.keymap.set('t', '<M-h>', '<Cmd>wincmd h<CR>', { desc = 'Goto right window' })
vim.keymap.set('t', '<M-j>', '<Cmd>wincmd j<CR>', { desc = 'Goto left window' })
vim.keymap.set('t', '<M-k>', '<Cmd>wincmd k<CR>', { desc = 'Goto down window' })
vim.keymap.set('t', '<M-l>', '<Cmd>wincmd l<CR>', { desc = 'Goto up window' })

vim.keymap.set({ 'n', 'x' }, 'x', '"_x', { desc = 'Delete char' })

vim.keymap.set('c', '<C-x>', function()
  return vim.fn.getcmdtype() == ':' and vim.fn.expand('%:p') or ''
end, { expr = true })

vim.keymap.set('s', '<BS>', '<BS>i')
vim.keymap.set('s', '<C-h>', '<C-h>i')

vim.keymap.set('n', '-', function()
  vim.cmd.edit('%:p:h')
end, { desc = 'Open parent directory' })
vim.keymap.set('n', '<Leader>cd', function()
  vim.cmd.tcd('%:p:h')
end, { desc = 'Change directory' })
vim.keymap.set('n', '<Leader>ud', function()
  vim.cmd.tcd('..')
end, { desc = 'Up directory' })

vim.keymap.set(
  'n',
  'gm',
  [[<Cmd>echo repeat("\n",&cmdheight)<Bar>40messages<CR>]],
  { desc = 'Messages' }
)
vim.keymap.set('n', 'gs', [[:%s/\<<C-R><C-W>\>\C//g<left><left>]], { desc = 'Substitute word' })

vim.iter({ 'cc', 'dd', 'yy' }):each(function(v)
  vim.keymap.set('n', v, function()
    return vim.api.nvim_get_current_line():match('^%s*$') and '"_' .. v or v
  end, { expr = true, desc = 'Smart ' .. v })
end)

vim.iter({ '"', "'", '`' }):each(function(v)
  vim.keymap.set({ 'x', 'o' }, v, 'i' .. v, { desc = 'Text object shortcuts' })
end)

-- Idea: |mini.basics|
vim.keymap.set('n', [[\c]], '<Cmd>setlocal cul! cul?<CR>', { desc = 'Toggle cursorline' })
vim.keymap.set('n', [[\C]], '<Cmd>setlocal cuc! cuc?<CR>', { desc = 'Toggle cursorcolumn' })
vim.keymap.set('n', [[\f]], '<Cmd>setlocal fen! fen?<CR>', { desc = 'Toggle fold' })
-- vim.keymap.set('n', [[\i]], '<Cmd>setlocal ic! ic?<CR>', { desc = 'Toggle ignorecase' })
vim.keymap.set('n', [[\l]], '<Cmd>setlocal list! list?<CR>', { desc = 'Toggle list' })
vim.keymap.set('n', [[\n]], '<Cmd>setlocal nu! nu?<CR>', { desc = 'Toggle number' })
vim.keymap.set('n', [[\N]], '<Cmd>setlocal rnu! rnu?<CR>', { desc = 'Toggle relativenumber' })
vim.keymap.set('n', [[\s]], '<Cmd>setlocal spell! spell?<CR>', { desc = 'Toggle spell' })
vim.keymap.set('n', [[\w]], '<Cmd>setlocal wrap! wrap?<CR>', { desc = 'Toggle wrap' })
vim.keymap.set('n', [[\d]], function()
  if vim.diagnostic.is_disabled(0) then
    vim.diagnostic.enable(0)
  else
    vim.diagnostic.disable(0)
  end
end, { desc = 'Toggle diagnostic' })
vim.keymap.set('n', [[\i]], function()
  if vim.lsp.inlay_hint.is_enabled(0) then
    vim.lsp.inlay_hint.enable(0, false)
  else
    vim.lsp.inlay_hint.enable(0, true)
  end
end, { desc = 'Toggle inlay hints' })
