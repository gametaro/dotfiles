local stdin = false

local function setenv()
  if stdin then
    return
  end
  if vim.wo.diff then
    return
  end
  local should_ignore = vim.iter(vim.fn.argv()):any(function(arg)
    if string.match(arg, 'COMMIT_EDITMSG') then
      return true
    end
  end)
  if should_ignore then
    return
  end

  ---@type string|nil
  local file = vim.fs.find({ '.env' }, {
    type = 'file',
    upward = true,
    stop = vim.fs.dirname(vim.fn.getcwd()),
  })[1]
  if not file then
    return
  end

  local env = vim
    .iter(io.lines(file))
    :filter(function(line)
      return not vim.startswith(line, '#')
    end)
    :fold({}, function(acc, line)
      local name, value = unpack(vim.split(line, '='))
      value = string.gsub(value, [=[['"]]=], '') -- remove quotes
      value = vim.trim(value)
      acc[name] = value
      return acc
    end)

  if not vim.tbl_isempty(env) then
    vim.iter(env):each(function(name, value)
      vim.env[name] = value
    end)
    local messages = vim.map(function(name, value)
      return string.format('%s=%s', name, value)
    end, env)
    print(string.format('Set env: %s', table.concat(messages, ',')))
  end
end

vim.api.nvim_create_autocmd('StdinReadPre', {
  callback = function()
    stdin = true
  end,
})

vim.api.nvim_create_autocmd({ 'VimEnter', 'DirChanged' }, {
  callback = setenv,
  desc = 'Set environment variables from .env',
})
