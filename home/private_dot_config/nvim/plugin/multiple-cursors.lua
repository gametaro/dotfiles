-- Credit: http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/

vim.keymap.set('n', 'cn', '*``cgn', { desc = 'Cursor word' })
vim.keymap.set('n', 'cN', '*``cgN', { desc = 'Cursor word' })

vim.cmd.let({ 'g:mc', '=', [["y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>"]] })
-- vim.g.mc = [["y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>"]]

vim.keymap.set('x', 'cn', function()
  return vim.g.mc .. '``cgn'
end, { expr = true, desc = 'Cursor word' })
vim.keymap.set('x', 'cN', function()
  return vim.g.mc .. '``cgN'
end, { expr = true, desc = 'Cursor word' })

function _G.CR()
  vim.keymap.set(
    'n',
    '<CR>',
    '<Cmd>nnoremap <lt>CR> n@z<CR>q<Cmd>let @z=strpart(@z,0,strlen(@z)-1)<CR>n@z'
  )
end

vim.keymap.set('n', 'cq', '<Cmd>lua _G.CR()<CR>*``qz', { desc = 'Cursor word (Macro)' })
vim.keymap.set('n', 'cQ', '<Cmd>lua _G.CR()<CR>#``qz', { desc = 'Cursor word (Macro)' })
vim.keymap.set('x', 'cq', [[":\<C-u>lua _G.CR()\<CR>" . "gv" . g:mc . "``qz"]], { expr = true })
vim.keymap.set(
  'x',
  'cQ',
  [[":\<C-u>lua _G.CR()\<CR>" . "gv" . substitute(g:mc, '/', '?', 'g') . "``qz"]],
  { expr = true, desc = 'Cursor word (Macro)' }
)
