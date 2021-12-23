local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Nop
map('n', '+', '<Nop>', {})
map('n', '<C-h>', '<Nop>', {})
map('n', '<C-j>', '<Nop>', {})
map('n', '<C-k>', '<Nop>', {})
map('n', '<C-n>', '<Nop>', {})
map('n', '<C-p>', '<Nop>', {})
map('n', '<C-z>', '<Nop>', {})
map('n', '<S-Tab>', '<Nop>', {})
map('n', '<Tab>', '<Nop>', {})
map('n', 'ZQ', '<Nop>', {})
map('n', 'ZZ', '<Nop>', {})
map('n', '~', '<Nop>', {})
map('c', '<C-_>', '<Nop>', {})
map('c', '<C-j>', '<Nop>', {})
map('c', '<C-o>', '<Nop>', {})
map('c', '<C-x>', '<Nop>', {})
map('c', '<C-z>', '<Nop>', {})
map('i', '<C-_>', '<Nop>', {})
map('i', '<C-b>', '<Nop>', {})
map('i', '<C-z>', '<Nop>', {})

map('x', '=', '=gv', opts)

map('n', 'x', '"_x', opts)
map('n', '<Leader>c', '"_c', opts)
map('n', '<Leader>d', '"_d', opts)

-- swap ; for :
map('', ';', ':', { noremap = true })
map('', ':', ';', { noremap = true })

-- swap w, b, e for W, B, E (normal mode only)
-- WARN: experimental
map('n', 'w', 'W', { noremap = true })
map('n', 'W', 'w', { noremap = true })
map('n', 'b', 'B', { noremap = true })
map('n', 'B', 'b', { noremap = true })
map('n', 'e', 'E', { noremap = true })
map('n', 'E', 'e', { noremap = true })

map('n', '<Leader>w', '<Cmd>update<CR>', opts)
map('n', '<Leader>W', '<Cmd>update!<CR>', opts)
map('n', '<Leader>q', '<Cmd>quit<CR>', opts)
map('n', '<Leader>Q', '<Cmd>quit!<CR>', opts)

map('c', '<C-a>', '<Home>', { noremap = true })
map('c', '<C-b>', '<Left>', { noremap = true })
map('c', '<C-d>', '<Del>', { noremap = true })
map('c', '<C-e>', '<End>', { noremap = true })
map('c', '<C-f>', '<Right>', { noremap = true })
map('c', '<C-n>', '<Down>', { noremap = true })
map('c', '<C-p>', '<Up>', { noremap = true })

-- map('n', '/', '/\v', { noremap = true })
-- map('n', '?', '?\v', { noremap = true })
map('c', '%%', [[getcmdtype() == ':' ? expand('%:h').'/' : '%%']], { noremap = true, expr = true })
map('c', '::', [[getcmdtype() == ':' ? expand('%:p:h').'/' : '::']], { noremap = true, expr = true })
map('c', '/', [[getcmdtype() == '/' ? '\/' : '/']], { noremap = true, expr = true })
map('c', '?', [[getcmdtype() == '?' ? '\?' : '?']], { noremap = true, expr = true })

-- use `ALT+{h,j,k,l}` to navigate windows from any mode
-- @see :h terminal
map('n', '<M-h>', '<C-w>h', opts)
map('n', '<M-j>', '<C-w>j', opts)
map('n', '<M-k>', '<C-w>k', opts)
map('n', '<M-l>', '<C-w>l', opts)
map('i', '<M-h>', [[<C-\><C-n><C-w>h]], opts)
map('i', '<M-j>', [[<C-\><C-n><C-w>j]], opts)
map('i', '<M-k>', [[<C-\><C-n><C-w>k]], opts)
map('i', '<M-l>', [[<C-\><C-n><C-w>l]], opts)
map('t', '<M-h>', [[<C-\><C-n><C-W>h]], opts)
map('t', '<M-j>', [[<C-\><C-n><C-W>j]], opts)
map('t', '<M-k>', [[<C-\><C-n><C-W>k]], opts)
map('t', '<M-l>', [[<C-\><C-n><C-W>l]], opts)
map('t', '<Esc>', [[<C-\><C-n>]], opts)

map('n', '<M-,>', '<Cmd>bprevious<CR>', opts)
map('n', '<M-.>', '<Cmd>bnext<CR>', opts)
map('n', '<M-c>', '<Cmd>bdelete<CR>', opts)
map('n', '<M-C>', '<Cmd>bdelete!<CR>', opts)

-- @see https://github.com/justinmk/config/blob/master/.config/nvim/init.vim
map('c', '<M-e>', "<C-r>=fnameescape('')<Left><Left>", { noremap = true })
map('c', '<M-f>', "<C-r>=fnamemodify(@%, ':t')<CR>", { noremap = true })
map('c', '<M-/>', [[\v^(()@!.)*$<Left><Left><Left><Left><Left><Left><Left>]], { noremap = true })
map('n', 'gm', [[<Cmd>set nomore<Bar>echo repeat("\n",&cmdheight)<Bar>40messages<Bar>set more<CR>]], {
  noremap = true,
})
-- split line at current cursor position
map('n', '<Leader>j', 'i<CR><Esc>k$', opts)

map('n', '<M-q>', '<Cmd>lua require"ky.utils".toggle_quickfix()<CR>', opts)

-- WARN: experimental
map('o', ')', 't)', opts)
map('o', '(', 't(', opts)
map('x', ')', 't)', opts)
map('x', '(', 't(', opts)

-- @see https://github.com/mhinz/vim-galore#quickly-add-empty-lines
map('n', '[<Space>', "<Cmd>put! =repeat(nr2char(10), v:count1)<CR>'[", opts)
map('n', ']<Space>', '<Cmd>put =repeat(nr2char(10), v:count1)<CR>', opts)

map('n', '<Leader>e', [[<Cmd>execute 'edit .'<CR>]], { noremap = true })
map('n', '-', [[<Cmd>execute 'edit ' .. expand('%:p:h')<CR>]], { noremap = true })

map('n', '<Leader>cd', '<Cmd>tcd %:p:h <Bar> pwd<CR>', opts)
map('n', '<Leader>ud', '<Cmd>tcd .. <Bar> pwd<CR>', opts)

map('n', '<BS>', '<C-^>', opts)

-- tab
map('n', '<Leader>te', '<Cmd>tabedit %<CR>', opts)
map('n', '<Leader>tC', '<Cmd>tabclose!<CR>', opts)
map('n', '<Leader>tn', '<Cmd>tabnew<CR>', opts)
map('n', '<Leader>to', '<Cmd>tabonly<CR>', opts)
map('n', '<Leader>ts', '<Cmd>tab split<CR>', opts)
map('n', '<Leader>ti', '<Cmd>tabs<CR>', opts)
map('n', '<Leader>tl', [[<Cmd>execute 'tabmove ' . (v:count ? (v:count - 1) : '+1')<CR>]], opts)
map('n', '<Leader>th', [[<Cmd>execute 'tabmove ' . (v:count ? (v:count - 1) : '-1')<CR>]], opts)

map('i', '<M-o>', '<C-o>o', { noremap = true })
map('i', '<M-O>', '<C-o>O', { noremap = true })

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
-- TODO: convert to lua
-- @see: http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
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
