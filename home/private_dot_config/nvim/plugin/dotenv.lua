local stdin = false

local function setenv()
  if stdin then
    return
  end
  for _, arg in ipairs(vim.fn.argv()) do
    -- ignore gitcommit
    if string.match(arg, 'COMMIT_EDITMSG') then
      return
    end
  end

  ---@type string|nil
  local file = vim.fs.find({ '.env' }, { upward = true })[1]
  if not file then
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

  local messages = {}
  for name, value in pairs(env) do
    table.insert(messages, string.format('%s=%s', name, value))
  end

  print(string.format('Set env: %s', table.concat(messages, ',')))
end

vim.api.nvim_create_autocmd('StdinReadPre', {
  callback = function()
    stdin = true
  end,
})

vim.api.nvim_create_autocmd('VimEnter', {
  callback = setenv,
  desc = 'Set environment variables from .env',
})
