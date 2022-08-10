local utils = {}

local api = vim.api
local fn = vim.fn

do
  local notif_opts = {
    title = debug.getinfo(1, 'n').name,
    on_open = function(win)
      local buf = api.nvim_win_get_buf(win)
      api.nvim_buf_set_option(buf, 'filetype', 'markdown_inline')
    end,
  }

  ---toggle vim options
  ---@param name string
  ---@param values table
  ---@param opts? table
  utils.toggle_options = function(name, values, opts)
    local defaults = { silent = false }
    opts = vim.tbl_extend('force', defaults, opts or {})
    values = values or api.nvim_get_option_info(name).type == 'boolean' and { true, false }
    local value
    for i, v in ipairs(values) do
      if api.nvim_get_option_value(name, {}) == v then
        value = values[i == #values and 1 or i + 1]
        api.nvim_set_option_value(name, value, {})
        break
      end
    end
    if opts and not opts.silent then
      vim.notify(
        string.format('set `%s` to `%s`', vim.inspect(name), vim.inspect(value)),
        vim.log.levels.INFO,
        notif_opts
      )
    end
  end

  --- show highlight-groups at the cursor
  utils.synstack = function()
    local row, col = unpack(api.nvim_win_get_cursor(0))
    local items = fn.synstack(row, col + 1)
    if vim.tbl_isempty(items) then
      pcall(vim.cmd.TSHighlightCapturesUnderCursor)
    else
      for _, i1 in ipairs(items) do
        local i2 = fn.synIDtrans(i1)
        local n1 = fn.synIDattr(i1, 'name')
        local n2 = fn.synIDattr(i2, 'name')
        vim.notify(string.format('`%s` -> `%s`', n1, n2), vim.log.levels.INFO, notif_opts)
      end
    end
  end
end

---check nvim is running on headless mode
---@return boolean
utils.headless = #api.nvim_list_uis() == 0

---searches process tree for a process having a name in the `names` list
---@param rootpid integer
---@param names table
---@param acc? integer
---@return boolean
---@see https://github.com/justinmk/config/blob/master/.config/nvim/init.vim
utils.find_proc_in_tree = function(rootpid, names, acc)
  acc = acc or 0
  if acc > 9 then
    return false
  end
  local p = api.nvim_get_proc(rootpid)
  if p and vim.tbl_contains(names, p.name) then
    return true
  end
  local ids = api.nvim_get_proc_children(rootpid)
  for _, id in ipairs(ids) do
    if utils.find_proc_in_tree(id, names, 1 + acc) then
      return true
    end
  end
  return false
end

return utils
