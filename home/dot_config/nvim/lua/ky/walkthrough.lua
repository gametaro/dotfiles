local api = vim.api
local fn = vim.fn

local M = {}

local find = function(t, v)
  for i = 1, #t do
    if t[i] == v then
      return i
    end
  end
  return nil
end

local list_files = function(path)
  local files = {}
  for name, type in vim.fs.dir(path) do
    if type == 'file' then
      table.insert(files, name)
    end
  end
  return files
end

local walkthrough = function(opts)
  opts = opts or {}

  local target
  local full_filename = api.nvim_buf_get_name(0)
  local filename = fn.fnamemodify(full_filename, ':t')
  local dirname = vim.fs.dirname(full_filename)
  -- would be better if results was cached per directory?
  local files = list_files(dirname)
  local idx = find(files, filename)
  if idx == nil then
    return
  end
  if opts.next then
    if idx == #files then
      target = files[1]
    else
      target = files[idx + 1]
    end
  end
  if not opts.next then
    if idx == 1 then
      target = files[#files]
    else
      target = files[idx - 1]
    end
  end
  if target == nil then
    return
  end

  vim.cmd('edit ' .. dirname .. '/' .. target)
end

M.next_file = function(opts)
  opts = opts or {}
  opts.next = true
  walkthrough(opts)
end

M.prev_file = function(opts)
  opts = opts or {}
  opts.next = false
  walkthrough(opts)
end

return M
