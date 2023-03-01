vim.api.nvim_create_user_command('Env', function()
  ---@type string|nil
  local file = vim.fs.find({ '.env' }, { upward = true })[1]
  if not file then
    vim.notify('Not found', vim.log.levels.WARN)
    return
  end

  local env = {}
  for line in io.lines(file) do
    if not vim.startswith(line, '#') then
      local name, value = unpack(vim.split(line, '='))
      value = vim.trim(value)
      value = string.gsub(value, [=[['"]]=], '') -- remove single/double quotes
      vim.env[name] = value
      env[name] = value
    end
  end

  local messages = { string.format('Loaded from **%s**', file), '```bash' }
  for name, value in pairs(env) do
    table.insert(messages, string.format('%s=%s', name, value))
  end
  table.insert(messages, '```')

  vim.notify(table.concat(messages, '\n'), vim.log.levels.INFO, {
    title = 'dotenv',
    on_open = function(win)
      local buf = vim.api.nvim_win_get_buf(win)
      if not vim.api.nvim_buf_is_valid(buf) then
        return
      end
      vim.bo[buf].filetype = 'markdown'
    end,
  })
end, {})
