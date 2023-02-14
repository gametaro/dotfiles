-- [[
-- *edgemotion.txt*	move to the edge!
--
-- Author  : haya14busa <haya14busa@gmail.com>
-- Version : 0.9.0
-- License : MIT license {{{
--
--   Copyright (c) 2017 haya14busa
--
--   Permission is hereby granted, free of charge, to any person obtaining
--   a copy of this software and associated documentation files (the
--   "Software"), to deal in the Software without restriction, including
--   without limitation the rights to use, copy, modify, merge, publish,
--   distribute, sublicense, and/or sell copies of the Software, and to
--   permit persons to whom the Software is furnished to do so, subject to
--   the following conditions:
--   The above copyright notice and this permission notice shall be
--   included in all copies or substantial portions of the Software.
--
--   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
--   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
--   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
--   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
--   CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
--   TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
--   SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--
-- }}}
-- ]]

local M = {}

local DIRECTION = { FORWARD = 1, BACKWARD = 0 }

---@param s string
---@return boolean
local function iswhite(s)
  return string.match(s, '^%s+$') and true or false
end

---@param lnum integer
---@param vcol integer
---@return string
local function get_virtcol_char(lnum, vcol)
  local pattern = vim.fn.printf([[^.\{-}\zs\%%<%dv.\%%>%dv]], vcol + 1, vcol)
  return vim.fn.matchstr(vim.fn.getline(lnum), pattern)
end

---@param lnum integer
---@param vcol integer
---@return boolean
local function island(lnum, vcol)
  local c = get_virtcol_char(lnum, vcol)
  if c == '' then
    return false
  end
  if not iswhite(c) then
    return true
  end
  local pattern = vim.fn.printf([[^.\{-}\zs.\%%<%dv.\%%>%dv.]], vcol + 1, vcol)
  local m = vim.fn.matchstr(vim.fn.getline(lnum), pattern)
  local chars = vim.fn.split(m, [[\zs]])
  if #chars ~= 3 then
    return false
  end
  return not iswhite(chars[1]) and not iswhite(chars[3])
end

---@param dir integer
---@return string
function M.move(dir)
  local delta = dir == DIRECTION.FORWARD and 1 or -1
  local curswant = vim.fn.getcurpos()[4]
  if curswant > 100000 then
    vim.fn.winrestview({ curswant = vim.fn.getline('.'):len() - 1 })
  end
  local vcol = vim.fn.virtcol('.')
  local orig_lnum = vim.fn.line('.')

  local island_start = island(orig_lnum, vcol)
  local island_next = island(orig_lnum + delta, vcol)

  local should_move_to_land = not (island_start and island_next)
  local lnum = orig_lnum
  local last_lnum = vim.fn.line('$')

  if should_move_to_land then
    if island_start and not island_next then
      lnum = lnum + delta
    end
    while lnum ~= 0 and lnum <= last_lnum and not island(lnum, vcol) do
      lnum = lnum + delta
    end
  else
    while lnum ~= 0 and lnum <= last_lnum and island(lnum, vcol) do
      lnum = lnum + delta
    end
    lnum = lnum - delta
  end

  if lnum == 0 or lnum == last_lnum + 1 then
    return '<Ignore>'
  end

  local move_cmd = dir == DIRECTION.FORWARD and 'j' or 'k'
  return vim.fn.abs(lnum - orig_lnum) .. move_cmd
end

vim.keymap.set({ 'n', 'x' }, '<C-j>', function()
  return M.move(1)
end, { expr = true })

vim.keymap.set({ 'n', 'x' }, '<C-k>', function()
  return M.move(0)
end, { expr = true })

return M
