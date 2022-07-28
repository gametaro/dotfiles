local utils = require('ky.utils')

local map = vim.keymap.set
local api = vim.api
local cmd = vim.cmd
local fn = vim.fn
local fmt = string.format

---@param prefix string
---@return function
local prefix = function(prefix)
  return function(s)
    return prefix .. s
  end
end

local leader = prefix('<Leader>')

-- Nop
map('', '<Space>', '<Nop>')
map('', ',', '<Nop>')
map('n', 'ZQ', '<Nop>')
map('n', 'ZZ', '<Nop>')

-- for _, v in ipairs { 'j', 'k' } do
--   map('n', v, function()
--     return (vim.v.count > 5 and 'm`' .. vim.v.count or '') .. v
--   end, { expr = true })
-- end

for _, v in ipairs { 'c', 'C', 'd', 'D', 'x', 'X' } do
  local lhs = string.lower(v) == 'x' and v or leader(v)
  map(
    { 'n', 'x' },
    lhs,
    fmt('"_%s', v),
    { desc = 'does not store the deleted text in any register. see :help quote_' }
  )
end

for _, v in ipairs { 'cc', 'dd', 'yy' } do
  map('n', v, function()
    local row, _ = unpack(api.nvim_win_get_cursor(0))
    local lines = api.nvim_buf_get_lines(0, row - 1, row - 1 + vim.v.count1, true)
    return string.len(vim.trim(table.concat(lines))) == 0 and fmt('"_%s', v) or v
  end, { expr = true, desc = 'does not store the blank line in register. see :help quote_' })
end

map('n', leader('h'), ':<C-u>help<Space>')
map('n', leader('l'), ':<C-u>lua =')

-- swap ; for :
map('', ';', ':')
-- map('', ':', ';')
-- map('', 'q;', 'q:')

-- swap ' for `
map('n', "'", '`')
map('n', '`', "'")

-- save and quit
map('n', leader('w'), cmd.update)
map('n', leader('q'), cmd.quit)
map('n', leader('a'), cmd.quitall)
map('n', leader('e'), function()
  cmd.write()
  if vim.bo.filetype == 'lua' then cmd.luafile('%') end
end, { desc = 'write and execute current lua file' })

-- movement in insert/cmdline mode
map('!', '<C-p>', '<Up>')
map('!', '<C-n>', '<Down>')
map('!', '<C-f>', '<Right>')
map('!', '<C-b>', '<Left>')
map('i', '<C-a>', '<C-c>I')
map('c', '<C-a>', '<Home>')
map('!', '<C-e>', '<End>')
map('i', '<C-]>', '<Esc><Right>')
-- map('i', '<C-m>', '<C-g>u<C-m>')

map('c', '<M-b>', '<S-Left>')
map('c', '<M-f>', '<S-right>')

-- map({ 'n', 'x' }, 'p', ']p')
-- map({ 'n', 'x' }, 'P', '[p')

-- map('n', '/', '/\v')
-- map('n', '?', '?\v')

map('c', '<C-x>', function()
  return fn.getcmdtype() == ':' and fn.expand('%:p') or ''
end, { expr = true })

for _, v in ipairs { '/', '?' } do
  map('c', v, function()
    return fn.getcmdtype() == v and fmt([[\%s]], v) or v
  end, { expr = true, desc = fmt('escape %s', v) })
end

for _, v in ipairs { 'h', 'j', 'k', 'l' } do
  local lhs = fmt('<M-%s>', v)
  map('n', lhs, fmt('<C-w>%s', v))
  map('i', lhs, fmt([[<C-\><C-n><C-w>%s]], v))
  map('t', lhs, fmt('<Cmd>wincmd %s<CR>', v))
end

map('s', '<BS>', '<BS>i')
map('s', '<C-h>', '<C-h>i')

-- buffer
map('n', '<BS>', '<C-^>')
-- map('n', 'gb', function()
--   cmd('buffer #')
-- end)
map('t', [[<C-\>]], function()
  cmd.buffer('#')
end)
map('n', ']b', function()
  cmd.bnext { count = vim.v.count1 }
end)
map('n', '[b', function()
  cmd.bprevious { count = vim.v.count1 }
end)

-- see https://github.com/yuki-yano/zero.nvim
map({ 'n', 'x', 'o' }, '0', function()
  local row, col = unpack(api.nvim_win_get_cursor(0))
  local lines = api.nvim_buf_get_lines(0, row - 1, row, true)[1]
  return lines:sub(1, col):match('^%s+$') and '0' or '^'
end, { expr = true, desc = 'toggle `0` and `^`' })
map({ 'n', 'x', 'o' }, '$', function()
  local row, col = unpack(api.nvim_win_get_cursor(0))
  local lines = api.nvim_buf_get_lines(0, row - 1, row, true)[1]
  return lines:sub(col + 1 - lines:len()):match('^%s+$') and '$' or 'g_'
end, { expr = true, desc = 'toggle `$` and `g_`' })

-- see https://github.com/yuki-yano/dotfiles/blob/main/.vimrc
for _, v in ipairs { 'i', 'A' } do
  map('n', v, function()
    return (not api.nvim_get_current_line():match('^%s*$') or vim.bo.buftype == 'terminal') and v
      or '"_cc'
  end, {
    expr = true,
    desc = fmt('toggle `%s` and `"_cc` based on the current line', v),
  })
end

-- see https://github.com/justinmk/config/blob/master/.config/nvim/init.vim
map('c', '<M-e>', "<C-r>=fnameescape('')<Left><Left>")
-- map('c', '<M-f>', "<C-r>=fnamemodify(@%, ':t')<CR>")
map('c', '<M-/>', [[\v^(()@!.)*$<Left><Left><Left><Left><Left><Left><Left>]])
map('n', 'gm', [[<Cmd>echo repeat("\n",&cmdheight)<Bar>40messages<CR>]])

-- WARN: experimental
for _, v in ipairs { '"', "'", '`', '{', '(', '[' } do
  map('o', v, fmt('i%s', v), { desc = 'text object shortcuts' })
end

for _, v in ipairs { '"', "'", '`' } do
  map(
    { 'o', 'x' },
    fmt('a%s', v),
    fmt('2i%s', v),
    { desc = 'do not select blanks. see :help iquote' }
  )
end

map('n', leader('.'), function()
  cmd.edit('.')
end)
map('n', '-', function()
  cmd.edit(fn.expand('%:p:h'))
end)

map('n', leader('cd'), function()
  cmd.tcd { '%:p:h', nextcmd = 'pwd' }
end)
map('n', leader('ud'), function()
  cmd.tcd { '..', nextcmd = 'pwd' }
end)

-- quickfix
local _qf = 'q'
map('n', _qf, '<Nop>')
map('n', 'Q', _qf)
local qf = prefix(_qf)
map('n', qf('q'), function()
  local ok, msg = pcall(cmd.cc, { count = vim.v.count1 })
  if not ok then vim.notify(msg, vim.log.levels.WARN) end
end, { desc = 'go to specific error' })
map('n', qf('o'), cmd.copen)
map('n', qf('c'), cmd.cclose)
map('n', qf('t'), function()
  if fn.getqflist({ winid = 0 }).winid == 0 then
    cmd.copen()
  else
    cmd.cclose()
  end
end, { desc = 'toggle quickfix window' })
map('n', qf('l'), function()
  local ok, msg = pcall(cmd.clist)
  if not ok then vim.notify(msg, vim.log.levels.INFO) end
end)
map('n', qf('h'), function()
  local ok, msg = pcall(cmd.chistory, { count = vim.v.count1 })
  if not ok then vim.notify(msg, vim.log.levels.INFO) end
end)
map('n', qf('f'), function()
  vim.ui.select({
    'Yes',
    'No',
  }, {
    prompt = 'Free all the quickfix lists in the stack?:',
  }, function(choice)
    choice = choice or ''
    if choice == 'Yes' then fn.setqflist({}, 'f') end
  end)
end, { desc = 'free all the quickfix lists in the stack. see :help setqflist-examples' })
map('n', ']Q', function()
  local ok, _ = pcall(cmd.cnewer, { count = vim.v.count1 })
  if not ok then pcall(cmd.chistory) end
end)
map('n', '[Q', function()
  local ok, _ = pcall(cmd.colder, { count = vim.v.count1 })
  if not ok then pcall(cmd.chistory, { count = fn.getqflist({ nr = '$' }).nr }) end
end)
map('n', ']q', function()
  local ok, _ = pcall(cmd.cnext, { count = vim.v.count1 })
  if not ok then pcall(cmd.cfirst) end
end)
map('n', '[q', function()
  local ok, _ = pcall(cmd.cprevious, { count = vim.v.count1 })
  if not ok then pcall(cmd.clast) end
end)
map('n', 'gq', function()
  local winid = fn.getqflist({ winid = 0 }).winid
  if winid ~= 0 then
    cmd.cwindow()
    fn.win_gotoid(winid)
  end
end, { desc = 'go to quickfix window' })
map('n', qf('0'), function()
  pcall(cmd.cfirst)
end)
map('n', qf('$'), function()
  pcall(cmd.clast)
end)

-- locationlist
local loc = prefix('qw')
map('n', ']l', function()
  local ok = pcall(cmd.lnext, { count = vim.v.count1 })
  if not ok then pcall(cmd.lfirst) end
end)
map('n', '[l', function()
  local ok = pcall(cmd.lprevious, { count = vim.v.count1 })
  if not ok then pcall(cmd.llast) end
end)
map('n', ']L', function()
  local ok = pcall(cmd.lnewer, { count = vim.v.count1 })
  if not ok then pcall(cmd.lhistory) end
end)
map('n', '[L', function()
  local ok = pcall(cmd.lolder, { count = vim.v.count1 })
  if not ok then pcall(cmd.chistory, { count = fn.getloclist(0, { nr = 0 }).nr }) end
end)
map('n', loc('o'), function()
  local ok, msg = pcall(cmd.lopen)
  if not ok then vim.notify(msg, vim.log.levels.INFO) end
end)
map('n', loc('c'), cmd.lclose)
map('n', loc('t'), function()
  if fn.getloclist(0, { winid = 0 }).winid == 0 then
    cmd.lopen()
  else
    cmd.lclose()
  end
end, { desc = 'toggle quickfix window' })
map('n', loc('l'), function()
  local ok, msg = pcall(cmd.llist, { count = vim.v.count1 })
  if not ok then vim.notify(msg, vim.log.levels.INFO) end
end)
map('n', loc('h'), function()
  local ok, msg = pcall(cmd.lhistory)
  if not ok then vim.notify(msg, vim.log.levels.INFO) end
end)
map('n', 'gl', function()
  local winid = fn.getloclist(0, { winid = 0 }).winid
  if winid ~= 0 then
    cmd.lwindow()
    fn.win_gotoid(winid)
  end
end, { desc = 'go to location list window' })
map('n', loc('0'), function()
  pcall(cmd.lfirst)
end)
map('n', loc('$'), function()
  pcall(cmd.llast)
end)

-- map('i', '<M-j>', '<Esc>:m .+1<CR>==gi')
-- map('i', '<M-k>', '<Esc>:m .-2<CR>==gi')
map('x', '<M-j>', ":m '>+1<CR>gv=gv", { desc = 'move up line(s)' })
map('x', '<M-k>', ":m '<-2<CR>gv=gv", { desc = 'move down line(s)' })

map('n', 'J', 'mzJ`z', { desc = 'keep curosor position after joining' })
-- map('n', leader('j'), 'i<CR><Esc>k$', { desc = 'split line at current cursor position' })

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

map('n', '<F1>', function()
  local row, col = unpack(api.nvim_win_get_cursor(0))
  local items = fn.synstack(row, col + 1)
  if vim.tbl_isempty(items) then
    pcall(cmd.TSHighlightCapturesUnderCursor)
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

map('n', '<Leader>s', function()
  utils.toggle_options('laststatus', { 0, 3 })
end, { desc = 'toggle laststatus' })

map('n', '<Leader>S', function()
  utils.toggle_options('spell')
end)

map('n', '<F10>', function()
  utils.toggle_options('list')
  utils.toggle_options('number')
  utils.toggle_options('relativenumber')
  utils.toggle_options('signcolumn', { 'yes', 'no' })
end, { desc = 'toggle options for easier copy' })
