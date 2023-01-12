local config = {
  skip_captures = { 'punctuation', 'conceal' },
  skip_same_captures = false,
  skip_non_keyword = true,
  skip_non_keyword_captures = { 'label', 'string', 'comment', 'variable', 'text' },
  disable_captures = { 'comment' },
}

local function inspect()
  local items = vim.inspect_pos(nil, nil, nil, {
    syntax = true,
    extmarks = false,
    semantic_tokens = false,
  })
  local row = items.row
  local col = items.col
  local char = vim.api.nvim_get_current_line():sub(col + 1, col + 1)
  local captures = vim.tbl_map(function(ts)
    return ts.capture and ts.capture or {}
  end, items.treesitter)
  return row, col, captures, char
end

---@param captures table
---@param skip_captures table
---@return boolean
local function has_skip_capture(captures, skip_captures)
  local was_found = false
  for _, capture in ipairs(captures) do
    for _, skip_capture in ipairs(skip_captures) do
      if string.find(capture, skip_capture) then
        was_found = true
      end
    end
  end
  return was_found
end

---@param opts table
local function motion(opts)
  opts = opts or {}
  local key = opts.key

  local whichwrap = vim.o.whichwrap
  if
    vim.tbl_contains(
      { 'h', 'l' },
      key and not vim.tbl_contains(vim.tbl_keys(vim.opt.whichwrap:get()), key)
    )
  then
    vim.opt.whichwrap:append(key)
  end

  for _ = 1, vim.v.count1 do
    while true do
      local pre_row, pre_col, pre_captures = inspect()

      vim.cmd.normal({ key, bang = true })
      -- vim.cmd.execute(string.format([["normal %s"]], key))

      local post_row, post_col, post_captures, post_char = inspect()

      if pre_row == post_row and pre_col == post_col then
        goto theend
      end

      if #post_char == 0 then
        goto continue
      end

      if vim.tbl_isempty(post_captures) then
        goto theend
      end

      if config.skip_same_captures and vim.inspect(pre_captures) == vim.inspect(post_captures) then
        goto continue
      end

      if
        config.skip_non_keyword
        and has_skip_capture(post_captures, config.skip_non_keyword_captures)
        and not vim.regex([[\k]]):match_str(post_char)
      then
        goto continue
      end

      if not has_skip_capture(post_captures, config.skip_captures) then
        goto theend
      end

      ::continue::
    end

    ::theend::
  end

  if vim.o.whichwrap ~= whichwrap then
    vim.o.whichwrap = whichwrap
  end
end

vim.keymap.set('n', 'w', function()
  motion({ key = 'w' })
end)
vim.keymap.set('n', 'b', function()
  motion({ key = 'b' })
end)
vim.keymap.set('n', 'e', function()
  motion({ key = 'e' })
end)
