-- Idea: numb.nvim

local config = {
  number = true,
  cursorline = true,
  relativenumber = false,
  foldenable = false,
}

local peek_view
local peek_options

---@param win integer
---@param options table<string, unknown>
local function set_options(win, options)
  vim.iter(options):each(function(name, value)
    vim.api.nvim_set_option_value(name, value, { win = win, scope = 'local' })
  end)
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
  if not peek_view then
    local view = vim.fn.winsaveview()
    peek_view = view
  end

  if not peek_options then
    peek_options = vim.iter(config):fold({}, function(acc, name)
      acc[name] = vim.wo[win][name]
      return acc
    end)
  end
  local options = vim.iter(config):fold({}, function(acc, name)
    acc[name] = config[name]
    return acc
  end)
  set_options(win, options)

  row = clamp(row, 1, vim.api.nvim_buf_line_count(vim.api.nvim_win_get_buf(win)))
  vim.api.nvim_win_set_cursor(win, { row, 0 })

  vim.cmd.normal({ 'zz', bang = true })
end

---@param win integer
---@param abort boolean
local function unpeek(win, abort)
  set_options(win, peek_options)
  peek_options = nil
  if abort then
    vim.fn.winrestview(peek_view)
  else
    vim.cmd.normal({ 'zv', bang = true })
  end
  peek_view = nil
end

---@return boolean
local function is_peeking()
  return peek_view and peek_options
end

---@param win integer
local function on_changed(win)
  local cmdline = vim.fn.getcmdline()
  local match = cmdline:match('^%d+$')
  if match then
    peek(win, tonumber(match))
  elseif is_peeking() then
    unpeek(win, true)
  end
  vim.cmd.redraw()
end

---@param win integer
local function on_leave(win)
  if not is_peeking() then
    return
  end
  unpeek(win, vim.v.event.abort)
end

local group = vim.api.nvim_create_augroup('peek', {})
vim.api.nvim_create_autocmd('CmdlineChanged', {
  group = group,
  callback = function(a)
    if a.file == ':' then
      on_changed(vim.fn.bufwinid(a.buf))
    end
  end,
})
vim.api.nvim_create_autocmd('CmdlineLeave', {
  group = group,
  callback = function(a)
    if a.file == ':' then
      on_leave(vim.fn.bufwinid(a.buf))
    end
  end,
})
