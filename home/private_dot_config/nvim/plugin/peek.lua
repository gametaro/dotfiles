-- Idea: numb.nvim

local config = {
  number = true,
  cursorline = true,
  relativenumber = false,
  foldenable = false,
}

local win_options = vim.tbl_keys(config)

---@param win integer
---@param options table<string, unknown>
local function set_options(win, options)
  for name, value in pairs(options) do
    vim.api.nvim_set_option_value(name, value, { win = win, scope = 'local' })
  end
end

---@param value integer
---@param min integer
---@param max integer
local function clamp(value, min, max)
  if value < min then
    return min
  elseif value > max then
    return max
  end
  return value
end

---@param win integer
---@param row integer
local function peek(win, row)
  if not vim.w[win].peek_view then
    local view = vim.fn.winsaveview()
    vim.w[win].peek_view = view
  end

  local options = {}
  if not vim.w[win].peek_options then
    for _, option in ipairs(win_options) do
      options[option] = vim.wo[win][option]
    end
    vim.w[win].peek_options = options
  end
  for _, option in ipairs(win_options) do
    options[option] = config[option]
  end
  set_options(win, options)

  row = clamp(row, 1, vim.api.nvim_buf_line_count(vim.api.nvim_win_get_buf(win)))
  vim.api.nvim_win_set_cursor(win, { row, 0 })

  vim.cmd.normal({ 'zz', bang = true })
end

---@param win integer
---@param abort boolean
local function unpeek(win, abort)
  set_options(win, vim.w[win].peek_options)
  vim.w[win].peek_options = nil
  if abort then
    vim.fn.winrestview(vim.w[win].peek_view)
  else
    vim.cmd.normal({ 'zv', bang = true })
  end
  vim.w[win].peek_view = nil
end

---@param win integer
---@return boolean
local function is_peeking(win)
  return vim.w[win].peek_view and vim.w[win].peek_options
end

---@param win integer
local function on_changed(win)
  local cmdline = vim.fn.getcmdline()
  local match = cmdline:match('^%d+$')
  if match then
    peek(win, tonumber(match))
  elseif is_peeking(win) then
    unpeek(win, true)
  end
  vim.cmd.redraw()
end

---@param win integer
local function on_leave(win)
  if not is_peeking(win) then
    return
  end
  unpeek(win, vim.v.event.abort)
end

local group = vim.api.nvim_create_augroup('peek', {})
vim.api.nvim_create_autocmd('CmdlineChanged', {
  group = group,
  callback = function(a)
    on_changed(vim.fn.bufwinid(a.buf))
  end,
})
vim.api.nvim_create_autocmd('CmdlineLeave', {
  group = group,
  callback = function(a)
    on_leave(vim.fn.bufwinid(a.buf))
  end,
})
