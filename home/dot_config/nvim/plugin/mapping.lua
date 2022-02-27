local map = vim.keymap.set
local api = vim.api
local fn = vim.fn
local cmd = vim.cmd
local fmt = string.format

-- Nop
map('', '<Space>', '<Nop>')
map('', ',', '<Nop>')
map('n', 'ZQ', '<Nop>')
map('n', 'ZZ', '<Nop>')

for _, v in ipairs { 'j', 'k' } do
  map('n', v, function()
    return (vim.v.count > 5 and 'm`' .. vim.v.count or '') .. v
  end, { expr = true })
end

for _, v in ipairs { 'c', 'C', 'd', 'D', 'x', 'X' } do
  local lhs = string.lower(v) == 'x' and v or fmt('<Leader>%s', v)
  map(
    { 'n', 'x' },
    lhs,
    fmt('"_%s', v),
    { desc = 'does not store the deleted text in any register. see :help quote_' }
  )
end

map('n', 'dd', function()
  local lnum = fn.line('.')
  local lines = api.nvim_buf_get_lines(0, lnum - 1, lnum - 1 + vim.v.count1, true)
  return string.len(vim.trim(table.concat(lines))) == 0 and '"_dd' or 'dd'
end, { expr = true, desc = 'does not store the blank line in register. see :help quote_' })

map('n', '<Leader>h', ':<C-u>help<Space>')
map('n', '<Leader>l', ':<C-u>lua =')

-- swap ; for :
map('', ';', ':')
-- map('', ':', ';')
-- map('', 'q;', 'q:')

-- save and quit
map('n', '<Leader>w', '<Cmd>update<CR>')
map('n', '<Leader>q', '<Cmd>quit<CR>')
map('n', '<Leader>a', '<Cmd>quitall<CR>')
map('n', '<Leader>e', function()
  cmd('update')
  cmd('luafile %')
end, { desc = 'write and execute current lua file' })

for _, v in ipairs { '<C-u>', '<C-d>' } do
  map('n', v, fmt('%szz', v), { desc = 'keep cursor centered after movement' })
end

-- movement in insert/cmdline mode
map({ 'i', 'c' }, '<C-p>', '<Up>')
map({ 'i', 'c' }, '<C-n>', '<Down>')
map({ 'i', 'c' }, '<C-f>', '<Right>')
map({ 'i', 'c' }, '<C-b>', '<Left>')
map('i', '<C-a>', '<C-o>^')
map('c', '<C-a>', '<Home>')
map({ 'i', 'c' }, '<C-e>', '<End>')
map('i', '<C-]>', '<Esc><Right>')

map('i', '<M-o>', '<C-o>o')
map('i', '<M-O>', '<C-o>O')

map('c', '<M-b>', '<S-Left>')
map('c', '<M-f>', '<S-right>')

-- map('n', '/', '/\v', { noremap = true })
-- map('n', '?', '?\v', { noremap = true })

map('c', '%%', function()
  return fn.getcmdtype() == ':' and fn.expand('%:h') .. '/' or '%%'
end, { expr = true })
map('c', '::', function()
  return fn.getcmdtype() == ':' and fn.expand('%:p:h') .. '/' or '::'
end, { expr = true })

for _, v in ipairs { '/', '?' } do
  map('c', v, function()
    return fn.getcmdtype() == v and fmt([[\%s]], v) or v
  end, { expr = true, desc = fmt('escape %s', v) })
end

for _, v in ipairs { 'h', 'j', 'k', 'l' } do
  local desc = fmt('use `ALT+%s` to navigate windows from any mode', v)
  local lhs = fmt('<M-%s>', v)
  map('n', lhs, fmt('<C-w>%s', v), { desc = desc })
  map('i', lhs, fmt([[<C-\><C-n><C-w>%s]], v), { desc = desc })
  map('t', lhs, fmt('<Cmd>wincmd %s<CR>', v), { desc = desc })
end

-- buffer
map('n', '<BS>', '<C-^>')
map('n', 'gb', function()
  cmd('buffer #')
end)
map('t', [[<C-\>]], function()
  cmd('buffer #')
end)
map('n', '<Tab>', function()
  cmd('bnext')
end)
map('n', '<S-Tab>', function()
  cmd('bprevious')
end)

-- see https://github.com/yuki-yano/zero.nvim
map({ 'n', 'x', 'o' }, '0', function()
  local line = api.nvim_get_current_line()
  return string.match(string.sub(line, 1, fn.col('.') - 1), '^%s+$') and '0' or '^'
end, { expr = true, desc = 'toggle `0` and `^`' })
map({ 'n', 'x', 'o' }, '$', function()
  local line = api.nvim_get_current_line()
  return string.match(string.sub(line, -(string.len(line) - fn.col('.'))), '^%s+$') and '$' or 'g_'
end, { expr = true, desc = 'toggle `$` and `g_`' })

---check if the current line is blank
---@return boolean
local is_blank_line = function()
  return string.len(vim.trim(api.nvim_get_current_line())) == 0
end

-- see https://github.com/yuki-yano/dotfiles/blob/main/.vimrc
for _, v in ipairs { 'i', 'A' } do
  map('n', v, function()
    return (not is_blank_line() or vim.bo.buftype == 'terminal') and v or '"_cc'
  end, {
    expr = true,
    desc = fmt('toggle `%s` and `"_cc` based on the current line', v),
  })
end

-- see https://github.com/justinmk/config/blob/master/.config/nvim/init.vim
map('c', '<M-e>', "<C-r>=fnameescape('')<Left><Left>")
-- map('c', '<M-f>', "<C-r>=fnamemodify(@%, ':t')<CR>")
map('c', '<M-/>', [[\v^(()@!.)*$<Left><Left><Left><Left><Left><Left><Left>]])
map('n', 'gm', [[<Cmd>set nomore<Bar>echo repeat("\n",&cmdheight)<Bar>40messages<Bar>set more<CR>]])

-- WARN: experimental
for _, v in ipairs { '"', "'", '`', '{', '(', '[' } do
  map('o', v, fmt('i%s', v), { desc = 'text object shortcuts' })
end

for _, v in ipairs { '"', "'", '`' } do
  map({ 'o', 'x' }, fmt('a%s', v), fmt('2i%s', v), { desc = 'do not select blanks' })
end

map('n', '<Leader>.', function()
  cmd('edit .')
end)
map('n', '-', function()
  cmd('edit ' .. fn.expand('%:p:h'))
end)
map('n', '~', function()
  cmd('edit ' .. fn.expand('$HOME'))
end)
map('n', '+', function()
  local ok, util = pcall(require, 'lspconfig.util')
  local cwd = vim.loop.cwd()
  local path = ok and util.find_git_ancestor(cwd) or cwd
  cmd('edit ' .. path)
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

-- quickfix
map('n', 'q', '<Nop>')
map('n', 'Q', 'q')
map('n', 'qq', function()
  cmd(vim.v.count1 .. 'cc')
end, { desc = 'go to specific error' })
map('n', 'qo', function()
  cmd('copen')
end, { desc = 'open quickfix window' })
map('n', 'qc', function()
  cmd('cclose')
end, { desc = 'close quickfix window' })
map('n', 'qt', function()
  if fn.getqflist({ winid = 0 }).winid == 0 then
    cmd('copen')
  else
    cmd('cclose')
  end
end, { desc = 'toggle quickfix window' })
map('n', 'ql', function()
  local ok, msg = pcall(cmd, 'clist')
  if not ok then
    vim.notify(msg, vim.log.levels.WARN)
  end
end)
map('n', 'qh', function()
  local ok, msg = pcall(cmd, vim.v.count1 .. 'chistory')
  if not ok then
    vim.notify(msg, vim.log.levels.WARN)
  end
end)
map('n', 'qf', function()
  vim.ui.select({
    'Yes',
    'No',
  }, {
    prompt = 'Free all the quickfix lists in the stack?:',
  }, function(choice)
    choice = choice or ''
    if choice == 'Yes' then
      fn.setqflist({}, 'f')
    end
  end)
end, { desc = 'free all the quickfix lists in the stack. see :help setqflist-examples' })
map('n', ']Q', function()
  local ok, msg = pcall(cmd, vim.v.count1 .. 'cnewer')
  if not ok then
    vim.notify(msg, vim.log.levels.WARN)
  end
end)
map('n', '[Q', function()
  local ok, msg = pcall(cmd, vim.v.count1 .. 'colder')
  if not ok then
    vim.notify(msg, vim.log.levels.WARN)
  end
end)
map('n', ']q', function()
  local ok, _ = pcall(cmd, vim.v.count1 .. 'cnext')
  if not ok then
    pcall(cmd, 'cfirst')
  end
end)
map('n', '[q', function()
  local ok, _ = pcall(cmd, vim.v.count1 .. 'cprevious')
  if not ok then
    pcall(cmd, 'clast')
  end
end)
map('n', 'gq', function()
  local winid = fn.getqflist({ winid = 0 }).winid
  cmd('cwindow')
  return winid ~= 0 and fn.win_gotoid(winid)
end, { desc = 'go to quickfix window' })

-- map('i', '<M-j>', '<Esc>:m .+1<CR>==gi')
-- map('i', '<M-k>', '<Esc>:m .-2<CR>==gi')
map('x', '<M-j>', ":m '>+1<CR>gv=gv", { desc = 'move up line(s)' })
map('x', '<M-k>', ":m '<-2<CR>gv=gv", { desc = 'move down line(s)' })

map('n', 'J', 'mzJ`z', { desc = 'keep curosor position after joining' })
map('n', '<Leader>j', 'i<CR><Esc>k$', { desc = 'split line at current cursor position' })

map('x', 'gs', ':sort<CR>')

-- Multiple Cursors
-- TODO: convert to lua
-- @see: http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
cmd([[
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

---searches process tree for a process having a name in the `names` list
---@param rootpid number
---@param names table
---@param acc number
---@return boolean
---@see https://github.com/justinmk/config/blob/master/.config/nvim/init.vim
local function find_proc_in_tree(rootpid, names, acc)
  acc = acc or 0
  if acc > 9 or not fn.exists('*nvim_get_proc') then
    return false
  end
  local p = api.nvim_get_proc(rootpid)
  if fn.empty(p) ~= 1 and vim.tbl_contains(names, p.name) then
    return true
  end
  local ids = api.nvim_get_proc_children(rootpid)
  for _, id in ipairs(ids) do
    if find_proc_in_tree(id, names, 1 + acc) then
      return true
    end
  end
  return false
end

map('t', '<Esc>', function()
  local names = { 'nvim', 'fzf' }
  return find_proc_in_tree(vim.b.terminal_job_pid, names) and '<Esc>' or [[<C-\><C-n>]]
end, { expr = true, desc = [[toggle `<Esc>` and `<C-\><C-n>` according to process tree]] })

map('n', '<F1>', function()
  local items = fn.synstack(fn.line('.'), fn.col('.'))
  if fn.empty(items) == 1 then
    pcall(cmd, 'TSHighlightCapturesUnderCursor')
  else
    for _, i1 in ipairs(items) do
      local i2 = fn.synIDtrans(i1)
      local n1 = fn.synIDattr(i1, 'name')
      local n2 = fn.synIDattr(i2, 'name')
      print(fmt('%s -> %s', n1, n2))
    end
  end
end, { desc = 'show highlight-groups at the cursor' })

map('n', '<F2>', function()
  require('plenary.profile').start('profile.log', { flame = true })
end, { desc = 'start profiling with plenary' })
map('n', '<F3>', function()
  require('plenary.profile').stop()
end, { desc = 'stop profiling with plenary' })

map('n', '<F10>', function()
  vim.wo.list = not vim.wo.list
  vim.wo.number = not vim.wo.number
  vim.wo.relativenumber = not vim.wo.relativenumber
  vim.wo.signcolumn = vim.wo.signcolumn == 'yes' and 'no' or 'yes'
end, { desc = 'toggle options for easier copy' })
