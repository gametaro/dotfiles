-- [[
-- *niceblock.txt*	Make blockwise Visual mode more useful
--
-- Version 0.2.0
-- Script ID: ****
-- Copyright (C) 2012-2018 Kana Natsuno <https://whileimautomaton.net/>
-- License: MIT license  {{{
--     Permission is hereby granted, free of charge, to any person obtaining
--     a copy of this software and associated documentation files (the
--     "Software"), to deal in the Software without restriction, including
--     without limitation the rights to use, copy, modify, merge, publish,
--     distribute, sublicense, and/or sell copies of the Software, and to
--     permit persons to whom the Software is furnished to do so, subject to
--     the following conditions:
--
--     The above copyright notice and this permission notice shall be included
--     in all copies or substantial portions of the Software.
--
--     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
--     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
--     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
--     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
--     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
--     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
--     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
-- }}}
-- ]]

local map = {
  I = { v = '<C-v>I', V = '<C-v>^o^I', ['\22'] = 'I' },
  A = { v = '<C-v>A', V = '<C-v>0o$A', ['\22'] = 'A' },
  gI = { v = '<C-v>0I', V = '<C-v>0o$I', ['\22'] = '0I' },
}

vim.iter(map):each(function(k)
  vim.keymap.set('x', k, function()
    return map[k][vim.api.nvim_get_mode().mode]
  end, { expr = true })
end)