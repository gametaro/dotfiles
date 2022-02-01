local map = vim.keymap.set

-- Nop
map('', '<Space>', '<Nop>', { remap = true })
map('n', '+', '<Nop>')
map('n', '<C-n>', '<Nop>')
map('n', '<C-z>', '<Nop>')
map('n', 'Q', '<Nop>')
map('n', 'ZQ', '<Nop>')
map('n', 'ZZ', '<Nop>')
map('c', '<C-j>', '<Nop>')
map('c', '<C-o>', '<Nop>')
map('c', '<C-x>', '<Nop>')
map('c', '<C-z>', '<Nop>')
map('i', '<C-_>', '<Nop>')
-- map('i', '<C-l>', '<Nop>', {})
map('i', '<C-z>', '<Nop>')
map('n', 's', '<Nop>', { remap = true })

map('x', '=', '=gv')

map('n', 'x', '"_x')
map('n', 'X', '"_X')
map('n', 'dd', function()
  local lnum = vim.fn.line('.')
  local lines = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum - 1 + vim.v.count1, true)
  return string.len(vim.trim(table.concat(lines))) == 0 and '"_dd' or 'dd'
end, { expr = true })

map('n', '<Leader>c', '"_c')
map('n', '<Leader>d', '"_d')

map('n', '<Leader>h', ':<C-u>help<Space>')

-- swap ; for :
map('', ';', ':')
-- map('', ':', ';')
map('', 'q;', 'q:')

-- save and quit
map('n', '<Leader>w', '<Cmd>confirm update<CR>')
map('n', '<Leader>q', '<Cmd>confirm quit<CR>')
map('n', '<Leader>a', '<Cmd>confirm quitall<CR>')

-- keep cursor centered after movement
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')
map('n', '<C-f>', '<C-f>zz')
map('n', 'G', 'Gzz')

-- move in inert mode
map('i', '<C-p>', '<Up>')
map('i', '<C-n>', '<Down>')
map('i', '<C-f>', '<Right>')
map('i', '<C-b>', '<Left>')
map('i', '<C-a>', '<Esc>^i')
map('i', '<C-e>', '<End>')

map('i', '<M-o>', '<C-o>o')
map('i', '<M-O>', '<C-o>O')
-- WARN: experimental
-- map('i', ',', ',<Space>', )

-- move in cmdline mode
map('c', '<C-p>', '<Up>')
map('c', '<C-n>', '<Down>')
map('c', '<C-f>', '<Right>')
map('c', '<C-b>', '<Left>')
map('c', '<C-d>', '<Del>')
map('c', '<C-a>', '<Home>')
map('c', '<C-e>', '<End>')
map('c', '<M-b>', '<S-Left>')
map('c', '<M-f>', '<S-right>')

-- map('n', '/', '/\v', { noremap = true })
-- map('n', '?', '?\v', { noremap = true })

map('c', '%%', function()
  return vim.fn.getcmdtype() == ':' and vim.fn.expand('%:h') .. '/' or '%%'
end, { expr = true })
map('c', '::', function()
  return vim.fn.getcmdtype() == ':' and vim.fn.expand('%:p:h') .. '/' or '::'
end, { expr = true })
map('c', '/', function()
  return vim.fn.getcmdtype() == '/' and [[\/]] or [[/]]
end, { expr = true })
map('c', '?', function()
  return vim.fn.getcmdtype() == '?' and [[\?]] or [[?]]
end, { expr = true })

-- use `ALT+{h,j,k,l}` to navigate windows from any mode
map('n', '<M-h>', '<C-w>h')
map('n', '<M-j>', '<C-w>j')
map('n', '<M-k>', '<C-w>k')
map('n', '<M-l>', '<C-w>l')
map('i', '<M-h>', [[<C-\><C-n><C-w>h]])
map('i', '<M-j>', [[<C-\><C-n><C-w>j]])
map('i', '<M-k>', [[<C-\><C-n><C-w>k]])
map('i', '<M-l>', [[<C-\><C-n><C-w>l]])
map('t', '<M-h>', '<Cmd>wincmd h<CR>')
map('t', '<M-j>', '<Cmd>wincmd j<CR>')
map('t', '<M-k>', '<Cmd>wincmd k<CR>')
map('t', '<M-l>', '<Cmd>wincmd l<CR>')

-- buffer
map('n', '<BS>', '<Nop>', { remap = true })
map('n', '<BS>', '<C-^>')
map('n', '<M-.>', '<Cmd>bnext<CR>')
map('n', '<M-,>', '<Cmd>bprevious<CR>')
map('n', '<M-c>', '<Cmd>bdelete<CR>')
map('n', '<M-C>', '<Cmd>bdelete!<CR>')

-- toggle `0` and `^`
-- see https://github.com/yuki-yano/zero.nvim
map({ 'n', 'x', 'o' }, '0', function()
  return string.match(string.sub(vim.api.nvim_get_current_line(), 0, vim.fn.col('.') - 1), '^%s+$')
        ~= nil
      and '0'
    or '^'
end, { expr = true })

-- toggle `i`, `A` and `cc`
-- see https://github.com/yuki-yano/dotfiles/blob/main/.vimrc
map('n', 'i', function()
  local is_blank_line = string.len(vim.trim(vim.api.nvim_get_current_line())) == 0
  return (not is_blank_line or vim.bo.buftype == 'terminal') and 'i' or '"_cc'
end, { expr = true })
map('n', 'A', function()
  local is_blank_line = string.len(vim.trim(vim.api.nvim_get_current_line())) == 0
  return (not is_blank_line or vim.bo.buftype == 'terminal') and 'A' or '"_cc'
end, { expr = true })

-- see https://github.com/justinmk/config/blob/master/.config/nvim/init.vim
map('c', '<M-e>', "<C-r>=fnameescape('')<Left><Left>")
-- map('c', '<M-f>', "<C-r>=fnamemodify(@%, ':t')<CR>")
map('c', '<M-/>', [[\v^(()@!.)*$<Left><Left><Left><Left><Left><Left><Left>]])
map('n', 'gm', [[<Cmd>set nomore<Bar>echo repeat("\n",&cmdheight)<Bar>40messages<Bar>set more<CR>]])

map('n', '<M-q>', function()
  if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
    vim.cmd('cclose')
  else
    vim.cmd('botright copen')
  end
end)

-- textobj shortcuts
-- WARN: experimental
map('o', '"', 'i"')
map('o', "'", "i'")
map('o', '`', 'i`')
map('o', '{', 'i{')
map('o', '(', 'i(')
map('o', '[', 'i[')

-- do not select blanks
map({ 'o', 'x' }, 'a"', '2i"')
map({ 'o', 'x' }, "a'", "2i'")
map({ 'o', 'x' }, 'a`', '2i`')

map('n', '<Leader>.', function()
  vim.cmd('edit .')
end)
map('n', '-', function()
  vim.cmd('edit ' .. vim.fn.expand('%:p:h'))
end)
map('n', '~', function()
  vim.cmd('edit ' .. vim.fn.expand('$HOME'))
end)
map('n', '+', function()
  local git_root = require('lspconfig.util').find_git_ancestor(vim.loop.cwd())
  if git_root then
    vim.cmd('edit ' .. git_root)
  end
end)

map('n', '<Leader>cd', '<Cmd>tcd %:p:h <Bar> pwd<CR>')
map('n', '<Leader>ud', '<Cmd>tcd .. <Bar> pwd<CR>')

-- tab
map('n', '<Leader>te', '<Cmd>tabedit %<CR>')
map('n', '<Leader>tc', '<Cmd>tabclose<CR>')
map('n', '<Leader>tC', '<Cmd>tabclose!<CR>')
map('n', '<Leader>tn', '<Cmd>tabnew<CR>')
map('n', '<Leader>to', '<Cmd>tabonly<CR>')
map('n', '<Leader>ts', '<Cmd>tab split<CR>')
map('n', '<Leader>ti', '<Cmd>tabs<CR>')
map('n', '<Leader>tl', [[<Cmd>execute 'tabmove +' . v:count1<CR>]])
map('n', '<Leader>th', [[<Cmd>execute 'tabmove -' . v:count1<CR>]])

-- move line(s)
-- map('i', '<M-j>', '<Esc>:m .+1<CR>==gi')
-- map('i', '<M-k>', '<Esc>:m .-2<CR>==gi')
map('x', '<M-j>', ":m '>+1<CR>gv=gv")
map('x', '<M-k>', ":m '<-2<CR>gv=gv")

-- keep curosor position after joining
map('n', 'J', 'mzJ`z')
-- split line at current cursor position
map('n', '<Leader>j', 'i<CR><Esc>k$')

-- Multiple Cursors
-- TODO: convert to lua
-- @see: http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
vim.cmd([[
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
]])

map('t', '<Esc>', function()
  local M = {}
  ---searches process tree for a process having a name in the `names` list
  ---https://github.com/justinmk/config/blob/master/.config/nvim/init.vim
  M.find_proc_in_tree = function(rootpid, names, acc)
    acc = acc or 0
    if acc > 9 or not vim.fn.exists('*nvim_get_proc') then
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
  return M.find_proc_in_tree(vim.b.terminal_job_pid, names) and '<Esc>' or [[<C-\><C-n>]]
end, { expr = true })

map('n', '<F1>', function()
  local fn = vim.fn
  local items = fn.synstack(fn.line('.'), fn.col('.'))
  if fn.empty(items) ~= 1 then
    for _, i1 in ipairs(items) do
      local i2 = fn.synIDtrans(i1)
      local n1 = fn.synIDattr(i1, 'name')
      local n2 = fn.synIDattr(i2, 'name')
      print(string.format('%s -> %s', n1, n2))
    end
  end
end)

-- profile
map('n', '<F2>', function()
  require('plenary.profile').start('profile.log', { flame = true })
end)
map('n', '<F3>', function()
  require('plenary.profile').stop()
end)
