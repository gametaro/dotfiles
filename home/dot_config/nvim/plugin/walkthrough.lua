local api = vim.api
local fs = vim.fs

local walkthrough = {}

---@alias walkthrough.List.Type 'file'|'directory'

---@class walkthrough.List.Options
---@field public type walkthrough.List.Type
---@field public ignore? function
---@field public sort? function

---@class walkthrough.Options
---@field public next boolean
---@field public type walkthrough.List.Type
---@field public silent? boolean
---@field public ignore? function
---@field public sort? function

---@param t table
---@param v table
local index_of = function(t, v)
  for i = 1, #t do
    if vim.inspect(t[i]) == vim.inspect(v) then
      return i
    end
  end
  return nil
end

---@param idx integer
---@param len integer
local next_index = function(idx, len)
  return idx == len and 1 or idx + 1
end

---@param idx integer
---@param len integer
local prev_index = function(idx, len)
  return idx == 1 and len or idx - 1
end

---@param a { name: string, type: walkthrough.List.Type }
---@param b { name: string, type: walkthrough.List.Type }
---@return boolean
local sort = function(a, b)
  if a.type == 'directory' and b.type ~= 'directory' then
    return true
  elseif a.type ~= 'directory' and b.type == 'directory' then
    return false
  end
  return a.name < b.name
end

---@param path string
---@param opts walkthrough.List.Options
---@return table
local list = function(path, opts)
  opts = opts or {}
  local f = {}
  for name, type in fs.dir(path) do
    if not opts.type or type == opts.type then
      f[#f + 1] = { name = name, type = type }
    end
  end
  table.sort(f, opts.sort and opts.sort or sort)
  return f
end

---@param msg string
---@param level? integer
---@param opts? table
local notify = function(msg, level, opts)
  opts = opts
    or {
      title = 'walkthrough.nvim',
      on_open = function(win)
        local buf = api.nvim_win_get_buf(win)
        api.nvim_buf_set_option(buf, 'filetype', 'markdown_inline')
      end,
    }
  level = level or vim.log.levels.WARN
  vim.notify(msg, level, opts)
end

---@param opts walkthrough.Options
walkthrough.walkthrough = function(opts)
  opts = opts or {}

  local full_filename = api.nvim_buf_get_name(0)
  local basename = fs.basename(full_filename)
  local dirname = fs.dirname(full_filename)
  local type = vim.fn.isdirectory(full_filename) == 0 and 'file' or 'directory'
  -- would be better if results were cached per directory?
  local f = list(dirname, { type = opts.type, ignore = opts.ignore, sort = opts.sort })
  if #f <= 1 then
    if not opts.silent then
      notify('Not found')
    end
    return
  end
  local idx = index_of(f, { name = basename, type = type })
  if not idx then
    if not opts.silent then
      notify(string.format('Not found `%s` in `%s`', basename, vim.inspect(f)))
    end
    return
  end
  local target_idx = opts.next and next_index(idx, #f) or prev_index(idx, #f)

  vim.cmd.edit(dirname .. '/' .. f[target_idx].name)
end

---Go to next file in current directory
---@param opts walkthrough.Options
walkthrough.next_file = function(opts)
  opts = opts or {}
  opts.next = true
  opts.type = 'file'
  walkthrough.walkthrough(opts)
end

---Go to previous file in current directory
---@param opts walkthrough.Options
walkthrough.prev_file = function(opts)
  opts = opts or {}
  opts.next = false
  opts.type = 'file'
  walkthrough.walkthrough(opts)
end

---Go to previous directory in current directory
---@param opts walkthrough.Options
walkthrough.next_dir = function(opts)
  opts = opts or {}
  opts.next = true
  opts.type = 'directory'
  walkthrough.walkthrough(opts)
end

---Go to previous directory in current directory
---@param opts walkthrough.Options
walkthrough.prev_dir = function(opts)
  opts = opts or {}
  opts.next = false
  opts.type = 'directory'
  walkthrough.walkthrough(opts)
end

---Go to next file/directory in current directory
---@param opts walkthrough.Options
walkthrough.next = function(opts)
  opts = opts or {}
  opts.next = true
  walkthrough.walkthrough(opts)
end

---Go to previous file/directory in current directory
---@param opts walkthrough.Options
walkthrough.prev = function(opts)
  opts = opts or {}
  opts.next = false
  walkthrough.walkthrough(opts)
end

vim.keymap.set(
  'n',
  ']w',
  walkthrough.next,
  { desc = 'Go to next file/directory in current directory' }
)
vim.keymap.set(
  'n',
  '[w',
  walkthrough.prev,
  { desc = 'Go to previous file/directory in current directory' }
)

return walkthrough
