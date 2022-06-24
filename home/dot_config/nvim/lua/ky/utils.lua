local utils = {}

---toggle vim options
---@param name string
---@param values table
---@param opts table
utils.toggle_options = function(name, values, opts)
  opts = vim.tbl_extend('force', { silent = false }, opts or {})
  values = values or vim.api.nvim_get_option_info(name).type == 'boolean' and { true, false }
  local value
  for i, v in ipairs(values) do
    if vim.api.nvim_get_option_value(name, {}) == v then
      value = values[i == #values and 1 or i + 1]
      vim.api.nvim_set_option_value(name, value, {})
      break
    end
  end
  if not opts.silent then
    vim.notify(string.format('set `%s` to `%s`', vim.inspect(name), vim.inspect(value)), 'info', {
      title = debug.getinfo(1, 'n').name,
      on_open = function(win)
        local buf = vim.api.nvim_win_get_buf(win)
        vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
      end,
    })
  end
end

---check nvim is running on headless mode
utils.headless = #vim.api.nvim_list_uis() == 0

return utils
