local config = {
  skip_captures = { 'punctuation', 'conceal', 'operator' },
  skip_same_captures = false,
  skip_not_is_keyword = false,
  skip_not_is_keyword_captures = { 'label', 'string', 'comment', 'variable', 'text' },
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
  local captures = vim.tbl_map(function(ts)
    return ts.capture and ts.capture or nil
  end, items.treesitter)
  return row, col, captures
end

---@param col integer
---@return string
local current_char = function(col)
  return vim.api.nvim_get_current_line():sub(col + 1, col + 1)
end

---@param captures table
---@return boolean
local function has_skip_capture(captures)
  local was_found = false
  for _, capture in ipairs(captures) do
    for _, skip_capture in ipairs(config.skip_captures) do
      if string.find(capture, skip_capture) then
        was_found = true
      end
    end
  end
  return was_found
end

---@param captures table
---@return boolean
local function has_skip_not_is_keyword_capture(captures)
  local was_found = false
  for _, capture in ipairs(captures) do
    for _, skip_capture in ipairs(config.skip_not_is_keyword_captures) do
      if string.find(capture, skip_capture) then
        was_found = true
      end
    end
  end
  return was_found
end

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

      local post_row, post_col, post_captures = inspect()
      if pre_row == post_row and pre_col == post_col then
        goto theend
      end

      if vim.tbl_isempty(post_captures) then
        goto theend
      end

      if config.skip_same_captures and vim.inspect(pre_captures) == vim.inspect(post_captures) then
        goto continue
      end

      if
        config.skip_not_is_keyword
        and has_skip_not_is_keyword_capture(post_captures)
        and not vim.regex([[\k]]):match_str(current_char(post_col))
      then
        goto continue
      end

      if not has_skip_capture(post_captures) then
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
