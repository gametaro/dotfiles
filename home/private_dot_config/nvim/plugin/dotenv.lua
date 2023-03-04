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

  local messages = { string.format('Loaded from %s', file) }
  for name, value in pairs(env) do
    table.insert(messages, string.format('%s=%s', name, value))
  end

  vim.notify(table.concat(messages, '\n'), vim.log.levels.INFO, { title = 'dotenv' })
end, {})
