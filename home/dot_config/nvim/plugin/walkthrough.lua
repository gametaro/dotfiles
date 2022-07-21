local api = vim.api
local fn = vim.fn

---@class walkthrough.Options
---@field public next boolean

---@param t table
---@param v any
---@return integer?
local index_of = function(t, v)
  for i = 1, #t do
    if t[i] == v then return i end
  end
  return nil
end

---@param idx integer
---@param len integer
---@return integer
local next_index = function(idx, len)
  return idx == len and 1 or idx + 1
end

---@param idx integer
---@param len integer
---@return integer
local prev_index = function(idx, len)
  return idx == 1 and len or idx - 1
end

---@param path string
---@return string[]
local list_files = function(path)
  local files = {}
  for name, type in vim.fs.dir(path) do
    if type == 'file' then files[#files + 1] = name end
  end
  return files
end

---@param opts walkthrough.Options
local walkthrough = function(opts)
  opts = opts or {}

  local target_idx
  local full_filename = api.nvim_buf_get_name(0)
  local filename = fn.fnamemodify(full_filename, ':t')
  local dirname = vim.fs.dirname(full_filename)
  -- would be better if results were cached per directory?
  local files = list_files(dirname)
  local idx = index_of(files, filename)
  if idx == nil then return end
  if opts.next then
    target_idx = next_index(idx, #files)
  else
    target_idx = prev_index(idx, #files)
  end
  if target_idx == nil then return end

  vim.cmd.edit(dirname .. '/' .. files[target_idx])
end

---@param opts walkthrough.Options
local next_file = function(opts)
  opts = opts or {}
  opts.next = true
  walkthrough(opts)
end

---@param opts walkthrough.Options
local prev_file = function(opts)
  opts = opts or {}
  opts.next = false
  walkthrough(opts)
end

vim.keymap.set('n', '<Leader>j', next_file, { desc = 'Go to next file in current directory' })
vim.keymap.set('n', '<Leader>k', prev_file, { desc = 'Go to previous file in current directory' })
