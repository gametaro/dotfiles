local api = vim.api
local fs = vim.fs

---@class walkthrough.Options
---@field public next boolean
---@field public type 'file'|'directory'
---@field public silent boolean

---@param t table
---@param v string
local index_of = function(t, v)
  for i = 1, #t do
    if t[i] == v then
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

---@param path string
---@param type 'file'|'directory'
---@return table
local list = function(path, type)
  local f = {}
  for name, _type in fs.dir(path) do
    if _type == type then
      f[#f + 1] = name
    end
  end
  return f
end

---@param opts walkthrough.Options
local walkthrough = function(opts)
  opts = opts or {}

  local full_filename = api.nvim_buf_get_name(0)
  local filename = fs.basename(full_filename)
  local dirname = fs.dirname(full_filename)
  -- would be better if results were cached per directory?
  local f = list(dirname, opts.type)
  if #f <= 1 then
    return
  end
  local idx = index_of(f, filename)
  if not idx then
    if not opts.silent then
      vim.notify('Not found', vim.log.levels.WARN, { title = 'walkthrough.nvim' })
    end
    return
  end
  local target_idx = opts.next and next_index(idx, #f) or prev_index(idx, #f)

  vim.cmd.edit(dirname .. '/' .. f[target_idx])
end

---Go to next file in current directory
---@param opts walkthrough.Options
local next_file = function(opts)
  opts = opts or {}
  opts.next = true
  opts.type = 'file'
  walkthrough(opts)
end

---Go to previous file in current directory
---@param opts walkthrough.Options
local prev_file = function(opts)
  opts = opts or {}
  opts.next = false
  opts.type = 'file'
  walkthrough(opts)
end

---Go to previous directory in parent directory
---@param opts walkthrough.Options
local next_dir = function(opts)
  opts = opts or {}
  opts.next = true
  opts.type = 'directory'
  walkthrough(opts)
end

---Go to previous directory in parent directory
---@param opts walkthrough.Options
local prev_dir = function(opts)
  opts = opts or {}
  opts.next = false
  opts.type = 'directory'
  walkthrough(opts)
end

vim.keymap.set('n', ']w', next_file, { desc = 'Go to next file in current directory' })
vim.keymap.set('n', '[w', prev_file, { desc = 'Go to previous file in current directory' })
vim.keymap.set('n', ']W', next_dir, { desc = 'Go to next directory in parent directory' })
vim.keymap.set('n', '[W', prev_dir, { desc = 'Go to previous directory in parent directory' })
