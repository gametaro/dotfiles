-- Credit: vim-smartword
-- Note: does not support operator-peding mode

---Get the character under the cursor
---@return string
local function get_char()
  return vim.fn.strcharpart(vim.fn.strpart(vim.fn.getline('.'), vim.fn.col('.') - 1), 0, 1)
end

---Move the cursor using the given motion, skipping over non-word characters
---@param motion string
local function move(motion)
  ---@type integer
  local count = vim.v.count1
  local curpos = vim.fn.getpos('.')
  local dstpos

  for _ = 1, count do
    repeat
      dstpos = curpos
      vim.cmd.normal({ motion, bang = true })
      curpos = vim.fn.getpos('.')
    until vim.regex([[\k]]):match_str(get_char()) or vim.deep_equal(dstpos, curpos)
  end
end

vim.iter({ 'w', 'b', 'e', 'ge' }):each(function(motion)
  vim.keymap.set({ 'n', 'x' }, motion, function()
    move(motion)
  end)
end)
