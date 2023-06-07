local M = {}

---@alias walkthrough.List.Type 'file'|'directory'

---@alias walkthrough.List.Item { name: string, type: walkthrough.List.Type }

---@class walkthrough.List.Options
---@field public type walkthrough.List.Type
---@field public skip? fun(dir_name: string): boolean
---@field public sort? fun(a: walkthrough.List.Item, a: walkthrough.List.Item): boolean

---@class walkthrough.Options
---@field public next boolean
---@field public type walkthrough.List.Type
---@field public silent? boolean
---@field public skip? fun(dir_name: string): boolean
---@field public sort? fun(a: walkthrough.List.Item, a: walkthrough.List.Item): boolean

---@type table<string, uv_fs_event_t>
local watchers = {}
---@type table<string, walkthrough.List.Item[]>
local files_per_dir = {}

---@param t table
---@param v table
local function index_of(t, v)
  for i = 1, #t do
    if vim.deep_equal(t[i], v) then
      return i
    end
  end
  return nil
end

---@param idx integer
---@param len integer
local function next_index(idx, len)
  return idx == len and 1 or idx + 1
end

---@param idx integer
---@param len integer
local function prev_index(idx, len)
  return idx == 1 and len or idx - 1
end

---@param a walkthrough.List.Item
---@param b walkthrough.List.Item
---@return boolean
local function sort(a, b)
  if a.type == 'directory' and b.type ~= 'directory' then
    return true
  elseif a.type ~= 'directory' and b.type == 'directory' then
    return false
  end
  return a.name < b.name
end

---@param path string
---@param opts? walkthrough.List.Options
---@return walkthrough.List.Item[]
local function list(path, opts)
  opts = vim.tbl_extend('force', { sort = sort }, opts or {})
  local f = vim.iter(vim.fs.dir(path, { skip = opts.skip })):fold({}, function(acc, name, type)
    if not opts.type or type == opts.type then
      acc[#acc + 1] = { name = name, type = type }
    end
    return acc
  end)
  table.sort(f, opts.sort)
  return f
end

---@param msg string
---@param level? integer
---@param opts? table
local function notify(msg, level, opts)
  level = level or vim.log.levels.WARN
  opts = opts
    or {
      title = 'walkthrough.nvim',
      on_open = function(win)
        local buf = vim.api.nvim_win_get_buf(win)
        vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown_inline')
      end,
    }
  vim.notify(msg, level, opts)
end

-- jscpd:ignore-start
---@param fn function
---@param ms integer
---@return function
local function throttle_leading(fn, ms)
  local timer = vim.uv.new_timer()
  local running = false

  return function(...)
    if not running then
      if timer then
        timer:start(ms, 0, function()
          running = false
          timer:stop()
        end)
      end
      running = true
      pcall(vim.schedule_wrap(fn), select(1, ...))
    end
  end
end
-- jscpd:ignore-end

---@param path string
---@param err any
---@param filename string
---@param events table
local function on_change(path, err, filename, events)
  if err then
    notify(err, vim.log.levels.ERROR)
    return
  end
  -- ignore :write, :saveas, and :update
  -- see https://github.com/neovim/neovim/issues/3460
  if filename and filename == '4913' then
    return
  end
  files_per_dir[path] = list(path)
end

local throttle_on_change = throttle_leading(function(path, ...)
  on_change(path, ...)
end, 1000)

---@param path string
local function watch(path)
  if watchers[path] then
    return
  end

  watchers[path] = vim.uv.new_fs_event()
  watchers[path]:start(path, {}, function(...)
    throttle_on_change(path, ...)
  end)
end

---@param opts walkthrough.Options
function M.walkthrough(opts)
  opts = opts or {}

  local fullname = vim.api.nvim_buf_get_name(0)
  local basename = vim.fs.basename(fullname)
  local dirname = vim.fs.dirname(fullname)
  local type = vim.fn.isdirectory(fullname) == 0 and 'file' or 'directory'

  local files = files_per_dir[dirname]
  if not files then
    watch(dirname)
    files = list(dirname, { type = opts.type, skip = opts.skip, sort = opts.sort })
  end
  if #files <= 1 then
    if not opts.silent then
      notify('Not found')
    end
    return
  end

  local idx = index_of(files, { name = basename, type = type })
  if not idx then
    if not opts.silent then
      notify(string.format('Not found `%s` in `%s`', basename, vim.inspect(files)))
    end
    return
  end

  local count = vim.v.count1 - 1
  local target_idx = opts.next and (next_index(idx, #files) + count)
    or (prev_index(idx, #files) - count)

  vim.cmd.edit(dirname .. '/' .. files[target_idx].name)
end

---Go to next file/directory in current directory
---@param opts walkthrough.Options
function M.next(opts)
  opts = opts or {}
  opts.next = true
  M.walkthrough(opts)
end

---Go to previous file/directory in current directory
---@param opts walkthrough.Options
function M.prev(opts)
  opts = opts or {}
  opts.next = false
  M.walkthrough(opts)
end

---Go to next file in current directory
---@param opts walkthrough.Options
function M.next_file(opts)
  opts = opts or {}
  opts.next = true
  opts.type = 'file'
  M.walkthrough(opts)
end

---Go to previous file in current directory
---@param opts walkthrough.Options
function M.prev_file(opts)
  opts = opts or {}
  opts.next = false
  opts.type = 'file'
  M.walkthrough(opts)
end

---Go to previous directory in current directory
---@param opts walkthrough.Options
function M.next_dir(opts)
  opts = opts or {}
  opts.next = true
  opts.type = 'directory'
  M.walkthrough(opts)
end

---Go to previous directory in current directory
---@param opts walkthrough.Options
function M.prev_dir(opts)
  opts = opts or {}
  opts.next = false
  opts.type = 'directory'
  M.walkthrough(opts)
end

vim.keymap.set('n', ']w', M.next, { desc = 'Next file or directory' })
vim.keymap.set('n', '[w', M.prev, { desc = 'Previous file or directory' })

return M
