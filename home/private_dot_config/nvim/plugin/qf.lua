local function is_open()
  if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
    return true
  end
  if vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 then
    return true
  end
  return false
end

local function open(keep_cursor)
  keep_cursor = keep_cursor or true

  local ok = pcall(vim.cmd.lwindow)
  if not ok then
    vim.cmd.cwindow()
  end
  if ok and keep_cursor then
    vim.cmd.wincmd('p')
  end
end

local function close()
  vim.cmd.cclose()
  vim.cmd.lclose()
end

local function toggle()
  if is_open() then
    close()
  else
    open()
  end
end

local function next()
  local ok1 = pcall(vim.cmd.cnext, { count = vim.v.count1 })
  if not ok1 then
    pcall(vim.cmd.cfirst)
  end
  local ok2 = pcall(vim.cmd.lnext, { count = vim.v.count1 })
  if not ok2 then
    pcall(vim.cmd.lfirst)
  end
end

local function prev()
  local ok1 = pcall(vim.cmd.cprevious, { count = vim.v.count1 })
  if not ok1 then
    pcall(vim.cmd.clast)
  end
  local ok2 = pcall(vim.cmd.lprevious, { count = vim.v.count1 })
  if not ok2 then
    pcall(vim.cmd.llast)
  end
end

local function first()
  pcall(vim.cmd.cfirst)
  pcall(vim.cmd.lfirst)
end

local function last()
  pcall(vim.cmd.clast)
  pcall(vim.cmd.llast)
end

vim.keymap.set('n', 'qq', toggle)
vim.keymap.set('n', 'qo', open)
vim.keymap.set('n', 'qc', close)
vim.keymap.set('n', 'q0', first)
vim.keymap.set('n', 'q$', last)
vim.keymap.set('n', ']q', next)
vim.keymap.set('n', '[q', prev)

-- |quickfix-window-function|
---@class Info
---@field quickfix 1|0
---@field winid integer
---@field id integer
---@field start_idx integer
---@field end_idx integer

---@param info Info
---@return unknown
local function items(info)
  return info.quickfix == 1 and vim.fn.getqflist({ id = info.id, items = 0 }).items
    or vim.fn.getloclist(info.winid, { id = info.id, items = 0 }).items
end

---@param fname string
---@param limit? integer
---@return string
local function format_fname(fname, limit)
  fname = fname == '' and '[No Name]' or vim.fn.fnamemodify(fname, ':p:.')
  fname = fname:gsub('^' .. vim.env.HOME, '~')
  limit = limit or 31

  local fname_fmt1 = '%-' .. limit .. 's'
  local fname_fmt2 = '…%.' .. (limit - 1) .. 's'

  -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
  return #fname <= limit and fname_fmt1:format(fname) or fname_fmt2:format(fname:sub(1 - limit))
end

-- |getqflist()|
---@class Item
---@field bufnr integer
---@field module string
---@field lnum integer
---@field end_lnum integer
---@field col integer
---@field end_col integer
---@field vcol boolean
---@field nr integer
---@field pattern string
---@field text string
---@field type string
---@field valid boolean

---@param item Item
local function format(item)
  local fname = item.bufnr > 0 and format_fname(vim.fn.bufname(item.bufnr)) or ''
  local lnum = item.lnum > 99999 and -1 or item.lnum
  local col = item.col > 999 and -1 or item.col
  local type = item.type == '' and '' or ' ' .. item.type:sub(1, 1):upper()
  local text = item.text
  return string.format('%s │%5d:%-3d│%s %s', fname, lnum, col, type, text)
end

---@param info table
---@return unknown
function _G.qftf(info)
  return vim.tbl_map(function(item)
    return item.valid == 1 and format(item) or item.text
  end, items(info))
end

vim.o.quickfixtextfunc = 'v:lua._G.qftf'
