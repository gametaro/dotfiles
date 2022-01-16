local set = vim.keymap.set

-- Nop
set('', '<Space>', '<Nop>', { remap = true })
set('n', '+', '<Nop>')
set('n', '<C-h>', '<Nop>')
set('n', '<C-n>', '<Nop>')
set('n', '<C-p>', '<Nop>')
set('n', '<C-z>', '<Nop>')
set('n', 'Q', '<Nop>')
set('n', 'ZQ', '<Nop>')
set('n', 'ZZ', '<Nop>')
set('c', '<C-j>', '<Nop>')
set('c', '<C-o>', '<Nop>')
set('c', '<C-x>', '<Nop>')
set('c', '<C-z>', '<Nop>')
set('i', '<C-_>', '<Nop>')
-- map('i', '<C-l>', '<Nop>', {})
set('i', '<C-z>', '<Nop>')
set('n', 's', '<Nop>', { remap = true })

set('x', '=', '=gv')

set('n', 'x', '"_x')
set('n', '<Leader>c', '"_c')
set('n', '<Leader>d', '"_d')

set('n', '<Leader>h', ':<C-u>help<Space>')

-- swap ; for :
set('', ';', ':')
set('', ':', ';')
set('', 'q;', 'q:')

-- save and quit
set('n', '<Leader>w', '<Cmd>update<CR>')
set('n', '<Leader>W', '<Cmd>update!<CR>')
set('n', '<Leader>q', '<Cmd>quit<CR>')
set('n', '<Leader>Q', '<Cmd>quit!<CR>')
set('n', '<Leader>a', '<Cmd>quitall<CR>')
set('n', '<Leader>A', '<Cmd>quitall!<CR>')

-- keep cursor centered after movement
set('n', '<C-o>', '<C-o>zz')
set('n', '<C-i>', '<C-i>zz')
set('n', '<C-d>', '<C-d>zz')
set('n', '<C-u>', '<C-u>zz')
set('n', '<C-f>', '<C-f>zz')
set('n', '<C-b>', '<C-b>zz')
set('n', 'G', 'Gzz')

-- move in inert mode
set('i', '<C-p>', '<Up>')
set('i', '<C-n>', '<Down>')
set('i', '<C-f>', '<Right>')
set('i', '<C-b>', '<Left>')
set('i', '<C-a>', '<Esc>^i')
set('i', '<C-e>', '<End>')

-- edit in inert mode
set('i', '<M-w>', '<Cmd>normal diw<CR>')
set('i', '<M-S-w>', '<Cmd>normal daw<CR>')
set('i', '<M-b>', '<Cmd>normal dib<CR>')
set('i', '<M-S-B>', '<Cmd>normal dab<CR>')
set('i', '<M-o>', '<C-o>o')
set('i', '<M-O>', '<C-o>O')
-- WARN: experimental
-- map('i', ',', ',<Space>', )

-- move in cmdline mode
set('c', '<C-p>', '<Up>')
set('c', '<C-n>', '<Down>')
set('c', '<C-f>', '<Right>')
set('c', '<C-b>', '<Left>')
set('c', '<C-d>', '<Del>')
set('c', '<C-a>', '<Home>')
set('c', '<C-e>', '<End>')

-- map('n', '/', '/\v', { noremap = true })
-- map('n', '?', '?\v', { noremap = true })

set('c', '%%', function()
  return vim.fn.getcmdtype() == ':' and vim.fn.expand '%:h' .. '/' or '%%'
end, { expr = true })
set('c', '::', function()
  return vim.fn.getcmdtype() == ':' and vim.fn.expand '%:p:h' .. '/' or '::'
end, { expr = true })
set('c', '/', function()
  return vim.fn.getcmdtype() == '/' and [[\/]] or [[/]]
end, { expr = true })
set('c', '?', function()
  return vim.fn.getcmdtype() == '/' and [[\/]] or [[/]]
end, { expr = true })

-- use `ALT+{h,j,k,l}` to navigate windows from any mode
-- see :h terminal
set('n', '<M-h>', '<C-w>h')
set('n', '<M-j>', '<C-w>j')
set('n', '<M-k>', '<C-w>k')
set('n', '<M-l>', '<C-w>l')
set('i', '<M-h>', [[<C-\><C-n><C-w>h]])
set('i', '<M-j>', [[<C-\><C-n><C-w>j]])
set('i', '<M-k>', [[<C-\><C-n><C-w>k]])
set('i', '<M-l>', [[<C-\><C-n><C-w>l]])
set('t', '<M-h>', [[<C-\><C-n><C-W>h]])
set('t', '<M-j>', [[<C-\><C-n><C-W>j]])
set('t', '<M-k>', [[<C-\><C-n><C-W>k]])
set('t', '<M-l>', [[<C-\><C-n><C-W>l]])
set('t', '<Esc>', [[<C-\><C-n>]])

-- buffer
set('n', '<BS>', '<C-^>')
set('n', '<M-.>', '<Cmd>bnext<CR>')
set('n', '<M-,>', '<Cmd>bprevious<CR>')
set('n', '<M-c>', '<Cmd>bdelete<CR>')
set('n', '<M-C>', '<Cmd>bdelete!<CR>')

-- toggle `0` and `^`
-- see https://github.com/yuki-yano/zero.nvim
set({ 'n', 'x', 'o' }, '0', function()
  return string.match(string.sub(vim.api.nvim_get_current_line(), 0, vim.fn.col '.' - 1), '^%s+$') ~= nil and '0' or '^'
end, { expr = true })

-- toggle `i`, `A` and `cc`
-- see https://github.com/yuki-yano/dotfiles/blob/main/.vimrc
set('n', 'i', function()
  return string.len(vim.trim(vim.api.nvim_get_current_line())) ~= 0 and 'i' or '"_cc'
end, { expr = true })
set('n', 'A', function()
  return string.len(vim.trim(vim.api.nvim_get_current_line())) ~= 0 and 'A' or '"_cc'
end, { expr = true })

-- see https://github.com/justinmk/config/blob/master/.config/nvim/init.vim
set('c', '<M-e>', "<C-r>=fnameescape('')<Left><Left>")
set('c', '<M-f>', "<C-r>=fnamemodify(@%, ':t')<CR>")
set('c', '<M-/>', [[\v^(()@!.)*$<Left><Left><Left><Left><Left><Left><Left>]])
set('n', 'gm', [[<Cmd>set nomore<Bar>echo repeat("\n",&cmdheight)<Bar>40messages<Bar>set more<CR>]])

set('n', '<M-q>', function()
  if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
    vim.cmd 'cclose'
  else
    vim.cmd 'botright copen'
  end
end)

-- textobj shortcuts
-- WARN: experimental
set('o', '"', 'i"')
set('o', "'", "i'")
set('o', '`', 'i`')
set('o', '{', 'i{')
set('o', '(', 'i(')
set('o', '[', 'i[')

-- do not select blanks
set({ 'o', 'x' }, 'a"', '2i"')
set({ 'o', 'x' }, "a'", "2i'")
set({ 'o', 'x' }, 'a`', '2i`')

-- see https://github.com/mhinz/vim-galore#quickly-move-current-line
set('n', '[e', "<Cmd>execute 'move -1-' . v:count1<CR>")
set('n', ']e', "<Cmd>execute 'move +' . v:count1<CR>")

-- see https://github.com/mhinz/vim-galore#quickly-add-empty-lines
set('n', '[<Space>', "<Cmd>put! =repeat(nr2char(10), v:count1)<CR>'[")
set('n', ']<Space>', '<Cmd>put =repeat(nr2char(10), v:count1)<CR>')

set('n', '<Leader>.', [[<Cmd>execute 'edit .'<CR>]])
set('n', '-', [[<Cmd>execute 'edit ' .. expand('%:p:h')<CR>]])
set('n', '~', [[<Cmd>execute 'edit ' .. expand('$HOME')<CR>]])
-- TODO: consider the case nil is returned
set('n', '+', function()
  vim.cmd('edit ' .. require('lspconfig.util').find_git_ancestor(vim.fn.getcwd()))
end)

set('n', '<Leader>cd', '<Cmd>tcd %:p:h <Bar> pwd<CR>')
set('n', '<Leader>ud', '<Cmd>tcd .. <Bar> pwd<CR>')

-- tab
set('n', '<Leader>te', '<Cmd>tabedit %<CR>')
set('n', '<Leader>tc', '<Cmd>tabclose<CR>')
set('n', '<Leader>tC', '<Cmd>tabclose!<CR>')
set('n', '<Leader>tn', '<Cmd>tabnew<CR>')
set('n', '<Leader>to', '<Cmd>tabonly<CR>')
set('n', '<Leader>ts', '<Cmd>tab split<CR>')
set('n', '<Leader>ti', '<Cmd>tabs<CR>')
set('n', '<Leader>tl', [[<Cmd>execute 'tabmove +' . v:count1<CR>]])
set('n', '<Leader>th', [[<Cmd>execute 'tabmove -' . v:count1<CR>]])

-- move line(s)
-- map('i', '<M-j>', '<Esc>:m .+1<CR>==gi')
-- map('i', '<M-k>', '<Esc>:m .-2<CR>==gi')
set('x', '<M-j>', ":m '>+1<CR>gv=gv")
set('x', '<M-k>', ":m '<-2<CR>gv=gv")

-- keep curosor position after joining
set('n', 'J', 'mzJ`z')
-- split line at current cursor position
set('n', '<Leader>j', 'i<CR><Esc>k$')

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

vim.keymap.set('t', '<Esc>', function()
  local M = {}
  ---searches process tree for a process having a name in the `names` list
  ---https://github.com/justinmk/config/blob/master/.config/nvim/init.vim
  M.find_proc_in_tree = function(rootpid, names, acc)
    if acc > 9 or not vim.fn.exists '*nvim_get_proc' then
      return false
    end
    local p = vim.api.nvim_get_proc(rootpid)
    if vim.fn.empty(p) ~= 1 and vim.tbl_contains(names, p.name) then
      return true
    end
    local ids = vim.api.nvim_get_proc_children(rootpid)
    for _, id in ipairs(ids) do
      if M.find_proc_in_tree(id, names, 1 + acc) then
        return true
      end
    end
    return false
  end
  local names = { 'nvim', 'fzf' }
  return M.find_proc_in_tree(vim.b.terminal_job_pid, names, 0) and '<Esc>' or [[<C-\><C-n>]]
end, { expr = true })

set('n', '<F1>', function()
  local items = vim.fn.synstack(vim.fn.line '.', vim.fn.col '.')
  if vim.fn.empty(items) ~= 1 then
    for _, i1 in ipairs(items) do
      local i2 = vim.fn.synIDtrans(i1)
      local n1 = vim.fn.synIDattr(i1, 'name')
      local n2 = vim.fn.synIDattr(i2, 'name')
      print(string.format('%s -> %s', n1, n2))
    end
  end
end)

-- profile
set('n', '<F2>', function()
  require('plenary.profile').start('profile.log', { flame = true })
end)
set('n', '<F3>', function()
  require('plenary.profile').stop()
end)
