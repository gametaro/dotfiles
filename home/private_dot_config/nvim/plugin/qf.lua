local fn = vim.fn

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
