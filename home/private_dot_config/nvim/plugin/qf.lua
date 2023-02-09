local fn = vim.fn

---@param info table
---@return unknown
local items = function(info)
  return info.quickfix == 1 and fn.getqflist({ id = info.id, items = 0 }).items
    or fn.getloclist(info.winid, { id = info.id, items = 0 }).items
end

---@param fname string
---@param limit integer
---@return string
local format_fname = function(fname, limit)
  fname = fname == '' and '[No Name]' or fn.fnamemodify(fname, ':p:.')
  fname = fname:gsub('^' .. vim.env.HOME, '~')
  limit = limit or 31

  local fname_fmt1 = '%-' .. limit .. 's'
  local fname_fmt2 = '…%.' .. (limit - 1) .. 's'

  -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
  return #fname <= limit and fname_fmt1:format(fname) or fname_fmt2:format(fname:sub(1 - limit))
end

---@param info table
---@return unknown
function _G.qftf(info)
  return vim.tbl_map(function(item)
    return item.valid ~= 1 and item.text
      or (function()
        local fname = item.bufnr > 0 and format_fname(fn.bufname(item.bufnr)) or ''
        local lnum = item.lnum > 99999 and -1 or item.lnum
        local col = item.col > 999 and -1 or item.col
        local qtype = item.type == '' and '' or ' ' .. item.type:sub(1, 1):upper()
        return string.format('%s │%5d:%-3d│%s %s', fname, lnum, col, qtype, item.text)
      end)()
  end, items(info))
end

vim.o.quickfixtextfunc = 'v:lua._G.qftf'
