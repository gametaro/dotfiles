local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Nop
map('', '<Space>', '<Nop>', {})
map('n', '+', '<Nop>', {})
map('n', '<C-h>', '<Nop>', {})
-- map('n', '<C-j>', '<Nop>', {})
-- map('n', '<C-k>', '<Nop>', {})
map('n', '<C-n>', '<Nop>', {})
map('n', '<C-p>', '<Nop>', {})
map('n', '<C-z>', '<Nop>', {})
map('n', '<S-Tab>', '<Nop>', {})
map('n', '<Tab>', '<Nop>', {})
map('n', '~', '<Nop>', {})
map('n', 'Q', '<Nop>', { noremap = true })
map('n', 'ZQ', '<Nop>', { noremap = true })
map('n', 'ZZ', '<Nop>', { noremap = true })
map('c', '<C-j>', '<Nop>', {})
map('c', '<C-o>', '<Nop>', {})
map('c', '<C-x>', '<Nop>', {})
map('c', '<C-z>', '<Nop>', {})
map('i', '<C-_>', '<Nop>', {})
map('i', '<C-l>', '<Nop>', {})
map('i', '<C-z>', '<Nop>', {})
map('', 's', '<Nop>', {})

map('x', '=', '=gv', opts)

map('n', 'x', '"_x', opts)
map('n', '<Leader>c', '"_c', opts)
map('n', '<Leader>d', '"_d', opts)

-- swap ; for :
map('', ';', ':', { noremap = true })
map('', ':', ';', { noremap = true })
map('', 'q;', 'q:', { noremap = true })

-- swap w, b, e for W, B, E (normal mode only)
-- WARN: experimental
map('n', 'w', 'W', { noremap = true })
map('n', 'W', 'w', { noremap = true })
map('n', 'b', 'B', { noremap = true })
map('n', 'B', 'b', { noremap = true })
map('n', 'e', 'E', { noremap = true })
map('n', 'E', 'e', { noremap = true })

-- save and quit
map('n', '<Leader>w', '<Cmd>update<CR>', opts)
map('n', '<Leader>W', '<Cmd>update!<CR>', opts)
map('n', '<Leader>q', '<Cmd>quit<CR>', opts)
map('n', '<Leader>Q', '<Cmd>quit!<CR>', opts)
map('n', '<Leader>a', '<Cmd>quitall<CR>', opts)
map('n', '<Leader>A', '<Cmd>quitall!<CR>', opts)

-- keep cursor centered after movement
map('n', '<C-o>', '<C-o>zz', opts)
map('n', '<C-i>', '<C-i>zz', opts)
map('n', '<C-d>', '<C-d>zz', opts)
map('n', '<C-u>', '<C-u>zz', opts)
map('n', '<C-f>', '<C-f>zz', opts)
map('n', '<C-b>', '<C-b>zz', opts)
map('n', 'G', 'Gzz', opts)
-- move in inert mode
map('i', '<C-p>', '<Up>', opts)
map('i', '<C-n>', '<Down>', opts)
map('i', '<C-f>', '<Right>', opts)
map('i', '<C-b>', '<Left>', opts)
map('i', '<C-a>', '<Esc>^i', opts)
map('i', '<C-e>', '<End>', opts)

-- edit in inert mode
map('i', '<M-w>', '<Cmd>normal diw<CR>', opts)
map('i', '<M-S-w>', '<Cmd>normal daw<CR>', opts)
map('i', '<M-b>', '<Cmd>normal dib<CR>', opts)
map('i', '<M-S-B>', '<Cmd>normal dab<CR>', opts)
map('i', '<M-o>', '<C-o>o', opts)
map('i', '<M-O>', '<C-o>O', opts)
-- WARN: experimental
map('i', ',', ',<Space>', opts)

-- move in cmdline mode
map('c', '<C-p>', '<Up>', { noremap = true })
map('c', '<C-n>', '<Down>', { noremap = true })
map('c', '<C-f>', '<Right>', { noremap = true })
map('c', '<C-b>', '<Left>', { noremap = true })
map('c', '<C-d>', '<Del>', { noremap = true })
map('c', '<C-a>', '<Home>', { noremap = true })
map('c', '<C-e>', '<End>', { noremap = true })

-- map('n', '/', '/\v', { noremap = true })
-- map('n', '?', '?\v', { noremap = true })
-- map('c', '%%', [[getcmdtype() == ':' ? expand('%:h').'/' : '%%']], { noremap = true, expr = true })
-- map('c', '::', [[getcmdtype() == ':' ? expand('%:p:h').'/' : '::']], { noremap = true, expr = true })
map('c', '/', [[getcmdtype() == '/' ? '\/' : '/']], { noremap = true, expr = true })
map('c', '?', [[getcmdtype() == '?' ? '\?' : '?']], { noremap = true, expr = true })

-- use `ALT+{h,j,k,l}` to navigate windows from any mode
-- see :h terminal
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

-- buffer
map('n', '<BS>', '<C-^>', opts)
map('n', '<Tab>', '<Cmd>bnext<CR>', opts)
map('n', '<S-Tab>', '<Cmd>bprevious<CR>', opts)
map('n', '<M-c>', '<Cmd>bdelete<CR>', opts)
map('n', '<M-C>', '<Cmd>bdelete!<CR>', opts)

-- see https://github.com/yuki-yano/dotfiles/blob/main/.vimrc
map('n', 'i', [[len(getline('.')) ? 'i' : '"_cc']], { noremap = true, expr = true })
map('n', 'A', [[len(getline('.')) ? 'A' : '"_cc']], { noremap = true, expr = true })

-- see https://github.com/justinmk/config/blob/master/.config/nvim/init.vim
map('c', '<M-e>', "<C-r>=fnameescape('')<Left><Left>", { noremap = true })
map('c', '<M-f>', "<C-r>=fnamemodify(@%, ':t')<CR>", { noremap = true })
map('c', '<M-/>', [[\v^(()@!.)*$<Left><Left><Left><Left><Left><Left><Left>]], { noremap = true })
map('n', 'gm', [[<Cmd>set nomore<Bar>echo repeat("\n",&cmdheight)<Bar>40messages<Bar>set more<CR>]], {
  noremap = true,
})

map('n', '<M-q>', '<Cmd>lua require"ky.utils".toggle_quickfix()<CR>', opts)

-- textobj shortcuts
-- WARN: experimental
-- map('o', ')', 't)', opts)
-- map('x', ')', 't)', opts)
map('o', '(', 't(', opts)
map('x', '(', 't(', opts)
map('o', ',', 't,', opts)
map('x', ',', 't,', opts)
map('o', "'", "i'", opts)
map('x', '"', 'i"', opts)
map('o', '}', 'i}', opts)
map('x', '}', 'i}', opts)
map('o', ')', 'i)', opts)
map('x', ')', 'i)', opts)
map('o', ']', 'i]', opts)
map('x', ']', 'i]', opts)

-- do not select blanks
map('o', 'a"', '2i"', opts)
map('x', 'a"', '2i"', opts)
map('o', "a'", "2i'", opts)
map('x', "a'", "2i'", opts)
map('o', 'a`', '2i`', opts)
map('x', 'a`', '2i`', opts)

-- see https://github.com/mhinz/vim-galore#quickly-move-current-line
map('n', '[e', "<Cmd>execute 'move -1-' . v:count1<CR>", { noremap = true })
map('n', ']e', "<Cmd>execute 'move +' . v:count1<CR>", { noremap = true })

-- see https://github.com/mhinz/vim-galore#quickly-add-empty-lines
map('n', '[<Space>', "<Cmd>put! =repeat(nr2char(10), v:count1)<CR>'[", opts)
map('n', ']<Space>', '<Cmd>put =repeat(nr2char(10), v:count1)<CR>', opts)

map('n', '<Leader>.', [[<Cmd>execute 'edit .'<CR>]], { noremap = true })
map('n', '-', [[<Cmd>execute 'edit ' .. expand('%:p:h')<CR>]], { noremap = true })
map('n', '~', [[<Cmd>execute 'edit ' .. expand('$HOME')<CR>]], { noremap = true })
-- TODO: consider the case nil is returned
map(
  'n',
  '+',
  [[<Cmd>lua vim.cmd('edit ' .. require('lspconfig.util').find_git_ancestor(vim.fn.getcwd()))<CR>]],
  { noremap = true }
)

map('n', '<Leader>cd', '<Cmd>tcd %:p:h <Bar> pwd<CR>', opts)
map('n', '<Leader>ud', '<Cmd>tcd .. <Bar> pwd<CR>', opts)

-- tab
map('n', '<Leader>te', '<Cmd>tabedit %<CR>', opts)
map('n', '<Leader>tc', '<Cmd>tabclose<CR>', opts)
map('n', '<Leader>tC', '<Cmd>tabclose!<CR>', opts)
map('n', '<Leader>tn', '<Cmd>tabnew<CR>', opts)
map('n', '<Leader>to', '<Cmd>tabonly<CR>', opts)
map('n', '<Leader>ts', '<Cmd>tab split<CR>', opts)
map('n', '<Leader>ti', '<Cmd>tabs<CR>', opts)
map('n', '<Leader>tl', [[<Cmd>execute 'tabmove +' . v:count1<CR>]], opts)
map('n', '<Leader>th', [[<Cmd>execute 'tabmove -' . v:count1<CR>]], opts)

-- move line(s)
-- map('i', '<M-j>', '<Esc>:m .+1<CR>==gi', opts)
-- map('i', '<M-k>', '<Esc>:m .-2<CR>==gi', opts)
map('x', '<M-j>', ":m '>+1<CR>gv=gv", opts)
map('x', '<M-k>', ":m '<-2<CR>gv=gv", opts)

-- keep curosor position after joining
map('n', 'J', 'mzJ`z', opts)
-- split line at current cursor position
map('n', '<Leader>j', 'i<CR><Esc>k$', opts)

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
