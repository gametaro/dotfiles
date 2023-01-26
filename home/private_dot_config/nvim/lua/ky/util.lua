local M = {}

---toggle vim options
---@param name string
---@param values table|nil
---@param opts table|nil
function M.toggle_options(name, values, opts)
  local defaults = { silent = false }
  opts = vim.tbl_extend('force', defaults, opts or {})
  values = values
    or (vim.api.nvim_get_option_info(name).type == 'boolean' and { true, false } or nil)
  if not values then
    vim.notify('No values specified', vim.log.levels.WARN, { title = 'toggle' })
    return
  end
  local value
  for i, v in ipairs(values) do
    if vim.api.nvim_get_option_value(name, {}) == v then
      value = values[i == #values and 1 or i + 1]
      vim.api.nvim_set_option_value(name, value, {})
      break
    end
  end
  if opts and not opts.silent then
    vim.notify(
      string.format('set `%s` to `%s`', vim.inspect(name), vim.inspect(value)),
      vim.log.levels.INFO,
      {
        title = 'toggle',
        on_open = function(win)
          local buf = vim.api.nvim_win_get_buf(win)
          vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown_inline')
        end,
      }
    )
  end
end

---check nvim is running on headless mode
---@return boolean
function M.headless()
  return #vim.api.nvim_list_uis() == 0
end

---@return boolean
function M.is_win()
  return vim.loop.os_uname().sysname:find('Windows') ~= nil
end

---searches process tree for a process having a name in the `names` list
---@param rootpid integer
---@param names table
---@param acc? integer
---@return boolean
---@see https://github.com/justinmk/config/blob/master/.config/nvim/init.vim
function M.find_proc_in_tree(rootpid, names, acc)
  acc = acc or 0
  if acc > 9 then
    return false
  end
  local p = vim.api.nvim_get_proc(rootpid)
  if p and vim.tbl_contains(names, p.name) then
    return true
  end
  local ids = vim.api.nvim_get_proc_children(rootpid)
  for _, id in ipairs(ids) do
    if M.find_proc_in_tree(id, names, 1 + acc) then
      return true
    end
  end
  return false
end

---@param cmd string
---@param args table
---@param callback function
function M.job(cmd, args, callback)
  local results = {}
  local handle
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)

  local on_read = function(err, data)
    if data then
      results[#results + 1] = vim.trim(data)
    end
  end

  local on_exit = function(code, signal)
    stdout:close()
    stderr:close()
    handle:close()

    callback(table.concat(results))
  end

  handle = vim.loop.spawn(cmd, {
    args = args,
    cwd = vim.loop.cwd(),
    stdio = {
      nil,
      stdout,
    },
  }, vim.schedule_wrap(on_exit))

  if handle then
    if stdout then
      stdout:read_start(on_read)
    end
  else
    if stdout then
      stdout:close()
      stderr:close()
    end
  end
end

---@return boolean
function M.is_git_repo()
  local root_dir
  for dir in vim.fs.parents(vim.api.nvim_buf_get_name(0)) do
    if vim.fn.isdirectory(dir .. '/.git') == 1 then
      root_dir = dir
      break
    end
  end
  return root_dir ~= nil
end

return M
