-- Idea: https://github.com/yuki-yano/zero.nvim

---@param s string
---@return boolean
local function is_blank(s)
  return string.match(s, '^%s+$') and true or false
end

vim.keymap.set({ 'n', 'x', 'o' }, '0', function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1]
  local first_char = line:sub(1, col)
  return is_blank(first_char) and '0' or '^'
end, { expr = true, desc = 'To the first non-blank character of the line' })

vim.keymap.set({ 'n', 'x', 'o' }, '$', function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1]
  local last_char = line:sub(col + 1 - line:len())
  return is_blank(last_char) and '$' or 'g_'
end, { expr = true, desc = 'To the last non-blank character of the line' })
