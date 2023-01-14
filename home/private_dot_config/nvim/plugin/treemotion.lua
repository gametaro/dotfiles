---@class treemotion.Option
---@field public key string a key of motion (e.g., `w`, `e`, `b`...)

---@class treemotion.Config
---@field public skip_captures string[] a list of captures to skip
---@field public disable_captures string[] a list of captures to disable
---@field public skip_same_captures boolean should skip continuous captures?
---@field public skip_non_keyword boolean should skip not `iskeyword` char?
---@field public skip_non_keyword_captures string[] a list of captures to skip non `iskeyword`

---@type treemotion.Config
local config = {
  -- pass to string.find
  skip_captures = { 'punctuation', 'conceal', 'operator' },
  disable_captures = { 'comment' },
  skip_same_captures = false,
  skip_non_keyword = true,
  skip_non_keyword_captures = { 'label', 'string', 'comment', 'variable', 'text' },
}

---@return number
---@return number
---@return table
---@return string
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

---@param captures string[]
---@param skip_captures string[]
---@return boolean
local function has_skip_capture(captures, skip_captures)
  local found = false
  for _, capture in ipairs(captures) do
    for _, skip_capture in ipairs(skip_captures) do
      if string.find(capture, skip_capture) then
        found = true
      end
    end
  end
  return found
end

---@param opts treemotion.Option
local function motion(opts)
  opts = opts or {}
  local key = opts.key

  for _ = 1, vim.v.count1 do
    while true do
      local pre_row, pre_col, pre_captures = inspect()

      vim.cmd.normal({ key, bang = true })
      -- vim.api.nvim_exec(string.format([["normal! $s"]], key), true)

      if config.disable_captures and has_skip_capture(pre_captures, config.disable_captures) then
        goto theend
      end

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
