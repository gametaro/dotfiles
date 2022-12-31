-- [[ smartword - Smart motions on words
--  Version: 0.1.1
--  Copyright (C) 2008-2015 Kana Natsuno <http://whileimautomaton.net/>
--  License: MIT license  {{{
--      Permission is hereby granted, free of charge, to any person obtaining
--      a copy of this software and associated documentation files (the
--      "Software"), to deal in the Software without restriction, including
--      without limitation the rights to use, copy, modify, merge, publish,
--      distribute, sublicense, and/or sell copies of the Software, and to
--      permit persons to whom the Software is furnished to do so, subject to
--      the following conditions:
--
--      The above copyright notice and this permission notice shall be included
--      in all copies or substantial portions of the Software.
--
--      THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
--      OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
--      MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
--      IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
--      CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
--      TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
--      SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
-- ]]

local api = vim.api
local cmd = vim.cmd
local fn = vim.fn

---@return string
local current_char = function()
  local _, col = unpack(api.nvim_win_get_cursor(0))
  return api.nvim_get_current_line():sub(col + 1, col + 1)
end

---@param motion string
---@param mode string
---@param times integer
local move = function(motion, mode, times)
  local firstpos = api.nvim_win_get_cursor(0)
  local newpos = firstpos
  local lastpos
  local lastiterpos

  for _ = 1, times do
    lastiterpos = newpos
    while true do
      lastpos = newpos

      cmd.execute(string.format([["normal \<Plug>CamelCaseMotion_%s"]], motion))
      if vim.o.selection == 'exclusive' and motion == 'e' and (mode == 'v' or mode == 'o') then
        cmd.normal({ 'h', bang = true })
      end
      newpos = api.nvim_win_get_cursor(0)

      if vim.regex([[\k]]):match_str(current_char()) then
        break
      end
      if vim.deep_equal(lastpos, newpos) then
        return
      end
    end
  end

  if motion == 'w' and mode == 'o' and lastiterpos[1] ~= newpos[1] then
    api.nvim_win_set_cursor(0, firstpos)
    cmd.normal({ 'v', bang = true })
    api.nvim_win_set_cursor(0, lastiterpos)
    cmd.normal({ '$h', bang = true })
  end

  if vim.o.selection == 'exclusive' and motion == 'e' and (mode == 'v' or mode == 'o') then
    cmd.normal({ 'l', bang = true })
  end
  if vim.o.selection == 'exclusive' and motion == 'ge' and mode == 'o' then
    cmd.normal({ 'ol', bang = true })
  end
end

---@param motion string
---@param mode string
local word_move = function(motion, mode)
  ---@type integer
  local count = vim.v.count1

  local exclusive_adjustment = false
  if mode == 'o' and (motion == 'e' or motion == 'ge') then
    local _mode = api.nvim_get_mode().mode
    if _mode == 'no' then
      cmd.normal({ 'v', bang = true })
    elseif _mode == 'nov' then
      cmd.normal({ 'v', bang = true })
      exclusive_adjustment = true
    elseif mode == 'noV' or mode == [[no\<C-v>]] then
    end
  end
  if mode == 'v' then
    cmd.normal({ 'gv', bang = true })
  end

  move(motion, mode, count)

  if exclusive_adjustment then
    cmd.execute({ [["normal! \<Esc>"]] })
    if fn.getpos("'<") == fn.getpos("'>") then
    else
      local original_whichwrap = vim.o.whichwrap
      vim.o.whichwrap = 'h'
      cmd.normal({ '`>', bang = true })
      cmd.normal({ 'h', bang = true })

      if fn.col('.') == fn.col('$') then
        cmd.normal({ 'h', bang = true })
      end
      if motion == 'ge' then
        cmd.normal({ 'v`<', bang = true })
      end
      vim.o.whichwrap = original_whichwrap
    end
  end
end

for _, mode in ipairs({ 'n', 'x', 'o' }) do
  for _, motion in ipairs({ 'w', 'b', 'e', 'ge' }) do
    vim.keymap.set(mode, motion, function()
      word_move(motion, mode)
    end)
  end
end
