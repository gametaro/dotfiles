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

---@param s string
---@return boolean
local function is_white(s)
  return string.match(s, '^%s+$')
end

---@param lnum integer
---@param vcol integer
---@return string
local function get_virtcol_char(lnum, vcol)
  local pattern = string.format([[^.\{-}\zs\%%<%dv.\%%>%dv]], vcol + 1, vcol)
  return vim.fn.matchstr(vim.fn.getline(lnum), pattern)
end

---@param lnum integer
---@param vcol integer
---@return boolean
local function is_edge(lnum, vcol)
  local char = get_virtcol_char(lnum, vcol)
  if char == '' then
    return false
  end
  if not is_white(char) then
    return true
  end
  local pattern = vim.fn.printf([[^.\{-}\zs.\%%<%dv.\%%>%dv.]], vcol + 1, vcol)
  local m = vim.fn.matchstr(vim.fn.getline(lnum), pattern)
  local chars = vim.split(m, '')
  return #chars == 3 and not (is_white(chars[1]) or is_white(chars[3]))
end

---@param opts table
local function move(opts)
  opts = opts or {}
  local delta = opts.forward and 1 or -1
  local vcol = vim.fn.virtcol('.')
  local orig_lnum = vim.fn.line('.')
  local lnum = orig_lnum
  local last_lnum = vim.fn.line('$')

  local edge_current = is_edge(orig_lnum, vcol)
  local edge_next = is_edge(orig_lnum + delta, vcol)

  if edge_current and edge_next then
    while lnum > 0 and lnum <= last_lnum and is_edge(lnum, vcol) do
      lnum = lnum + delta
    end
    lnum = lnum - delta
  else
    if edge_current and not edge_next then
      lnum = lnum + delta
    end
    while lnum > 0 and lnum <= last_lnum and not is_edge(lnum, vcol) do
      lnum = lnum + delta
    end
  end

  if lnum > 0 and lnum <= last_lnum then
    vim.cmd.normal({ vim.fn.abs(lnum - orig_lnum) .. (opts.forward and 'j' or 'k'), bang = true })
  end
end

local function forward(opts)
  opts = opts or {}
  opts.forward = true
  move(opts)
end

local function backward(opts)
  opts = opts or {}
  opts.forward = false
  move(opts)
end

vim.keymap.set({ 'n', 'x' }, '<C-j>', forward, { desc = 'Forward to edge' })
vim.keymap.set({ 'n', 'x' }, '<C-k>', backward, { desc = 'Backward to edge' })
