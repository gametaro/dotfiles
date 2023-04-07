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

---@alias Mode 'n' | 'x' | 'o'
---@alias Motion 'w' | 'b' | 'e' | 'ge'

---@return string
local function get_char()
  return vim.fn.strcharpart(vim.fn.strpart(vim.fn.getline('.'), vim.fn.col('.') - 1), 0, 1)
end

---@param motion Motion
---@param mode Mode
---@param times integer
local function move(motion, mode, times)
  local firstpos = vim.fn.getpos('.')
  local newpos = firstpos
  local lastpos
  local lastiterpos

  for _ = 1, times do
    lastiterpos = newpos
    repeat
      lastpos = newpos

      -- TODO: how to handle each motions to be dot-repeatable?
      vim.cmd.execute(string.format([["normal \<Plug>CamelCaseMotion_%s"]], motion))
      -- local key = vim.api.nvim_replace_termcodes(motion, true, true, true)
      -- vim.api.nvim_feedkeys(key, 'ntx', false)
      -- vim.cmd.normal({ motion, bang = true })
      if
        vim.o.selection == 'exclusive'
        and motion == 'e'
        and vim.tbl_contains({ 'x', 'o' }, mode)
      then
        vim.cmd.normal({ 'h', bang = true })
      end
      newpos = vim.fn.getpos('.')
    until vim.regex([[\k]]):match_str(get_char()) or vim.deep_equal(lastpos, newpos)
  end

  if motion == 'w' and mode == 'o' and lastiterpos[2] ~= newpos[2] then
    vim.fn.setpos('.', firstpos)
    vim.cmd.normal({ 'v', bang = true })
    vim.fn.setpos('.', lastiterpos)
    vim.cmd.normal({ '$h', bang = true })
  end

  if vim.o.selection == 'exclusive' then
    if motion == 'e' then
      if vim.tbl_contains({ 'x', 'o' }, mode) then
        vim.cmd.normal({ 'l', bang = true })
      end
    elseif motion == 'ge' then
      if vim.tbl_contains({ 'o' }, mode) then
        vim.cmd.normal({ 'ol', bang = true })
      end
    end
  end
end

---@param motion Motion
local function adjustment(motion)
  vim.print('adjustment')
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, true, true), 'n', false)
  if vim.deep_equal(vim.fn.getpos("'<"), vim.fn.getpos("'>")) then
  else
    local ww = vim.o.whichwrap
    vim.o.whichwrap = 'h'
    vim.cmd.normal({ '`>', bang = true })
    vim.cmd.normal({ 'h', bang = true })

    if vim.fn.col('.') == vim.fn.col('$') then
      vim.cmd.normal({ 'h', bang = true })
    end
    if motion == 'ge' then
      vim.cmd.normal({ 'v`<', bang = true })
    end
    vim.o.whichwrap = ww
  end
end

---@param motion Motion
---@param mode Mode
local function word_move(motion, mode)
  ---@type integer
  local count = vim.v.count1

  local exclusive_adjustment = false
  if mode == 'o' and vim.tbl_contains({ 'e', 'ge' }, motion) then
    local mode_ = vim.api.nvim_get_mode().mode
    vim.print(mode_, mode, motion)
    if mode_ == 'no' then
      vim.cmd.normal({ 'v', bang = true })
    elseif mode_ == 'nov' then
      vim.cmd.normal({ 'v', bang = true })
      exclusive_adjustment = true
    elseif vim.tbl_contains({ 'noV', [[no\<C-v>]] }, mode_) then
    end
  end
  -- if mode == 'x' then
  --   vim.cmd.normal({ 'gv', bang = true })
  -- end

  move(motion, mode, count)

  if exclusive_adjustment then
    adjustment(motion)
  end
end

for _, mode in ipairs({ 'n', 'x', 'o' }) do
  for _, motion in ipairs({ 'w', 'b', 'e', 'ge' }) do
    vim.keymap.set(mode, motion, function()
      word_move(motion, mode)
    end)
  end
end
