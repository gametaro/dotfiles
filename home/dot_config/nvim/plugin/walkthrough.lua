local api = vim.api
local fs = vim.fs

local walkthrough = {}

---@alias walkthrough.List.Type 'file'|'directory'

---@alias walkthrough.List.Item { name: string, type: walkthrough.List.Type }

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

---@type table<string, userdata>
local watchers = {}
---@type table<string, walkthrough.List.Item[]>
local dirfs = {}

---@param t table
---@param v table
local index_of = function(t, v)
  for i = 1, #t do
    if vim.deep_equal(t[i], v) then
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

---@param a walkthrough.List.Item
---@param b walkthrough.List.Item
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
---@return walkthrough.List.Item[]
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
  level = level or vim.log.levels.WARN
  opts = opts
    or {
      title = 'walkthrough.nvim',
      on_open = function(win)
        local buf = api.nvim_win_get_buf(win)
        api.nvim_buf_set_option(buf, 'filetype', 'markdown_inline')
      end,
    }
  vim.notify(msg, level, opts)
end

-- jscpd:ignore-start
---@param fn function
---@param ms integer
---@return function
local throttle_leading = function(fn, ms)
  local timer = vim.loop.new_timer()
  local running = false

  return function(...)
    if not running then
      timer:start(ms, 0, function()
        running = false
        timer:stop()
      end)
      running = true
      ---@diagnostic disable-next-line: param-type-mismatch
      pcall(vim.schedule_wrap(fn), select(1, ...))
    end
  end
end
-- jscpd:ignore-end

---@param path string
---@param err any
---@param filename string
---@param events table
local on_change = function(path, err, filename, events)
  if err then
    notify(err, vim.log.levels.ERROR)
    return
  end
  -- ignore :write, :saveas, and :update
  -- see https://github.com/neovim/neovim/issues/3460
  if filename and filename == '4913' then
    return
  end
  dirfs[path] = list(path)
end

local throttle_on_change = throttle_leading(function(path, ...)
  on_change(path, ...)
end, 1000)

---@param path string
local watch = function(path)
  if watchers[path] then
    return
  end

  watchers[path] = vim.loop.new_fs_event()
  watchers[path]:start(path, {}, function(...)
    throttle_on_change(path, ...)
  end)
end

---@param opts walkthrough.Options
walkthrough.walkthrough = function(opts)
  opts = opts or {}

  local fullname = api.nvim_buf_get_name(0)
  local basename = fs.basename(fullname)
  local dirname = fs.dirname(fullname)
  local type = vim.fn.isdirectory(fullname) == 0 and 'file' or 'directory'

  local f = dirfs[dirname]
  if not f then
    watch(dirname)
    f = list(dirname, { type = opts.type, ignore = opts.ignore, sort = opts.sort })
  end
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

  local count = vim.v.count1 - 1
  local target_idx = opts.next and (next_index(idx, #f) + count) or (prev_index(idx, #f) - count)

  vim.cmd.edit(dirname .. '/' .. f[target_idx].name)
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
