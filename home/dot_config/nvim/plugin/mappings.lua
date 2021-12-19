local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

map('n', 'ZZ', '<Nop>', opts)
map('n', 'ZQ', '<Nop>', opts)

map('x', '=', '=gv', opts)

map('n', 'x', '"_x', opts)

map('n', 'Q', 'q', opts)

map('c', '<C-a>', '<Home>', { noremap = true })
map('c', '<C-b>', '<Left>', { noremap = true })
map('c', '<C-d>', '<Del>', { noremap = true })
map('c', '<C-e>', '<End>', { noremap = true })
map('c', '<C-f>', '<Right>', { noremap = true })
map('c', '<C-n>', '<Down>', { noremap = true })
map('c', '<C-p>', '<Up>', { noremap = true })

map('c', '%%', [[getcmdtype() == ':' ? expand('%:h').'/' : '%%']], { noremap = true, expr = true })
map('c', '::', [[getcmdtype() == ':' ? expand('%:p:h').'/' : '::']], { noremap = true, expr = true })
map('c', '/', [[getcmdtype() == '/' ? '\/' : '/']], { noremap = true, expr = true })
map('c', '?', [[getcmdtype() == '?' ? '\?' : '?']], { noremap = true, expr = true })

map('n', '<M-h>', '<C-w>h', opts)
map('n', '<M-j>', '<C-w>j', opts)
map('n', '<M-k>', '<C-w>k', opts)
map('n', '<M-l>', '<C-w>l', opts)
map('i', '<M-h>', '<Esc><C-w>h', opts)
map('i', '<M-j>', '<Esc><C-w>j', opts)
map('i', '<M-k>', '<Esc><C-w>k', opts)
map('i', '<M-l>', '<Esc><C-w>l', opts)

map('n', '<Leader>q', '<Cmd>lua require"ky.utils".toggle_qf()<CR>', opts)

-- NOTE: https://github.com/mhinz/vim-galore#quickly-add-empty-lines
map('n', '[<Space>', "<Cmd>put! =repeat(nr2char(10), v:count1)<CR>'[", opts)
map('n', ']<Space>', '<Cmd>put =repeat(nr2char(10), v:count1)<CR>', opts)

map('n', '<Leader>cd', '<Cmd>tcd %:p:h<Bar>pwd<CR>', opts)
map('n', '<Leader>ud', '<Cmd>tcd ..<Bar>pwd<CR>', opts)

map('n', '<Leader>lq', '<Cmd> lua vim.diagnostic.setqflist()<CR>', opts)

map('n', '<BS>', '<C-^>', opts)

map('n', '<LocalLeader>tn', '<Cmd>tabnew<CR>', opts)
map('n', '<LocalLeader>tc', '<Cmd>tabclose<CR>', opts)
map('n', '<LocalLeader>te', '<Cmd>tabedit %<CR>', opts)

-- WARN: experimental
map('i', ',', ',<Space>', opts)

-- move line(s)
-- map('i', '<M-j>', '<Esc>:m .+1<CR>==gi', opts)
-- map('i', '<M-k>', '<Esc>:m .-2<CR>==gi', opts)
map('x', '<M-j>', ":m '>+1<CR>gv=gv", opts)
map('x', '<M-k>', ":m '<-2<CR>gv=gv", opts)

-- keep curosor position
map('n', 'J', 'mzJ`z', opts)

-- Multiple Cursors
-- NOTE: http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
vim.cmd [[
let g:mc = "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>"

nnoremap cn *``cgn
nnoremap cN *``cgN

xnoremap <expr> cn g:mc . "``cgn"
xnoremap <expr> cN g:mc . "``cgN"

function! SetupCR()
  nnoremap <Enter> :nnoremap <lt>Enter> n@z<CR>q:<C-u>let @z=strpart(@z,0,strlen(@z)-1)<CR>n@z
endfunction

nnoremap cq :call SetupCR()<CR>*``qz
nnoremap cQ :call SetupCR()<CR>#``qz

xnoremap <expr> cq ":\<C-u>call SetupCR()\<CR>" . "gv" . g:mc . "``qz"
xnoremap <expr> cQ ":\<C-u>call SetupCR()\<CR>" . "gv" . substitute(g:mc, '/', '?', 'g') . "``qz"
]]
