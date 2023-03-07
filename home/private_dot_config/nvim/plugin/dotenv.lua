local ignore_buftype = { 'quickfix', 'nofile', 'help', 'terminal' }
local ignore_filetype = { 'gitcommit', 'gitrebase', 'svn', 'hgcommit' }

local function setenv()
  if vim.tbl_contains(ignore_buftype, vim.bo.buftype) then
    return
  end

  if vim.tbl_contains(ignore_filetype, vim.bo.filetype) then
    return
  end

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
end

vim.api.nvim_create_autocmd('VimEnter', {
  callback = setenv,
  desc = 'Set dotenv',
})
