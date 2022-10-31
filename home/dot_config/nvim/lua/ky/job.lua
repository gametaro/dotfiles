---@param cmd string
---@param args table
---@param callback function
return function(cmd, args, callback)
  local results = {}
  local handle
  local stdout = vim.loop.new_pipe(false)

  local on_read = function(err, data)
    if err then
      vim.notify(err, vim.log.levels.WARN, { title = 'Job' })
    end
    if data then
      results[#results + 1] = vim.trim(data)
    end
  end

  local on_exit = function(code, signal)
    if stdout then
      stdout:close()
    end
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
    end
  end
end
