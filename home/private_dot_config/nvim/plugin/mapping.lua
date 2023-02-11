local util = require('ky.util')

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
map('', '<Space>', '')
map('', ',', '')
map('n', 'ZQ', '')
map('n', 'ZZ', '')

-- for _, v in ipairs { 'j', 'k' } do
--   map('n', v, function()
--     return (vim.v.count > 5 and 'm`' .. vim.v.count or '') .. v
--   end, { expr = true })
-- end

for _, v in ipairs({ 'c', 'C', 'd', 'D', 'x', 'X' }) do
  local lhs = string.lower(v) == 'x' and v or leader(v)
  map(
    { 'n', 'x' },
    lhs,
    fmt('"_%s', v),
    { desc = 'does not store the deleted text in any register. see :help quote_' }
  )
end

for _, v in ipairs({ 'cc', 'dd', 'yy' }) do
  map('n', v, function()
    local row, _ = unpack(api.nvim_win_get_cursor(0))
    local lines = api.nvim_buf_get_lines(0, row - 1, row - 1 + vim.v.count1, true)
    return string.len(vim.trim(table.concat(lines))) == 0 and fmt('"_%s', v) or v
  end, { expr = true, desc = 'does not store the blank line in register. see :help quote_' })
end

map('n', leader('h'), ':<C-u>help<Space>')

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
  if vim.bo.filetype == 'lua' then
    cmd.luafile('%')
  end
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

for _, v in ipairs({ '/', '?' }) do
  map('c', v, function()
    return fn.getcmdtype() == v and fmt([[\%s]], v) or v
  end, { expr = true, desc = fmt('escape %s', v) })
end

for _, v in ipairs({ 'h', 'j', 'k', 'l' }) do
  local lhs = fmt('<M-%s>', v)
  map('n', lhs, fmt('<C-w>%s', v))
  map('i', lhs, fmt([[<C-\><C-n><C-w>%s]], v))
  map('t', lhs, function()
    cmd.wincmd(v)
  end)
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
  cmd.bnext({ count = vim.v.count1 })
end)
map('n', '[b', function()
  cmd.bprevious({ count = vim.v.count1 })
end)

-- see https://github.com/justinmk/config/blob/master/.config/nvim/init.vim
map('c', '<M-e>', "<C-r>=fnameescape('')<Left><Left>")
-- map('c', '<M-f>', "<C-r>=fnamemodify(@%, ':t')<CR>")
map('c', '<M-/>', [[\v^(()@!.)*$<Left><Left><Left><Left><Left><Left><Left>]])
map('n', 'gm', [[<Cmd>echo repeat("\n",&cmdheight)<Bar>40messages<CR>]])

-- WARN: experimental
for _, v in ipairs({ '"', "'", '`', '{', '(', '[' }) do
  map('o', v, fmt('i%s', v), { desc = 'text object shortcuts' })
end

-- for _, v in ipairs { '"', "'", '`' } do
--   map(
--     { 'o', 'x' },
--     fmt('a%s', v),
--     fmt('2i%s', v),
--     { desc = 'do not select blanks. see :help iquote' }
--   )
-- end

map('n', leader('.'), function()
  cmd.edit('.')
end)
map('n', '-', function()
  cmd.edit(fn.expand('%:p:h'))
end)

map('n', leader('cd'), function()
  cmd.tcd('%:p:h')
  cmd.pwd()
end)
map('n', leader('ud'), function()
  cmd.tcd('..')
  cmd.pwd()
end)

-- map('i', '<M-j>', '<Esc>:m .+1<CR>==gi')
-- map('i', '<M-k>', '<Esc>:m .-2<CR>==gi')
map('x', '<M-j>', ":m '>+1<CR>gv=gv", { desc = 'move up line(s)' })
map('x', '<M-k>', ":m '<-2<CR>gv=gv", { desc = 'move down line(s)' })

map({ 'n', 'x' }, 'J', 'mzJ`z', { desc = 'keep curosor position after joining' })
-- map('n', leader('j'), 'i<CR><Esc>k$', { desc = 'split line at current cursor position' })

map('x', 'gs', ':sort<CR>')

map('n', '<Leader>i', function()
  vim.cmd.Inspect()
end)

map('n', '<Leader>s', function()
  util.toggle_options('laststatus', { 0, 3 })
end, { desc = 'toggle laststatus' })

map('n', '<Leader>S', function()
  util.toggle_options('spell')
end)

map('n', '<F10>', function()
  util.toggle_options('list')
  util.toggle_options('number')
  util.toggle_options('relativenumber')
  util.toggle_options('signcolumn', { 'yes', 'no' })
end, { desc = 'toggle options for easier copy' })
