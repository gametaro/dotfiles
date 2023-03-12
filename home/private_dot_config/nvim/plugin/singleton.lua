---@param file string
---@param cwd string
---@return string
local function fullpath(file, cwd)
  return vim.fs.normalize(vim.loop.fs_realpath(file) or cwd .. '/' .. file)
end

---@param args string[]
---@param cwd string
_G.diff = function(args, cwd)
  local files = vim.tbl_map(function(arg)
    return fullpath(arg, cwd)
  end, args)
  for i, file in ipairs(files) do
    if i == 1 then
      vim.cmd.tabnew(file)
    else
      vim.cmd.vsplit({ file, mods = { split = 'belowright' } })
    end
    vim.cmd.diffthis()
  end

  vim.cmd('%argdelete')
end

---@param lines string[]
---@param ft string
_G.stdin = function(lines, ft)
  vim.cmd.tabnew()
  vim.fn.setline(1, lines)
  vim.opt_local.readonly = true
  vim.opt_local.modified = false
  vim.opt_local.buftype = 'nofile'
  vim.opt_local.filetype = ft

  vim.cmd('%argdelete')
end

_G.args = function(args, cwd, address)
  local files = vim.tbl_map(function(arg)
    return fullpath(arg, cwd)
  end, args)
  vim.cmd.argadd({ args = files, addr = 'arg' })
  for i = 1, #files do
    vim.cmd.argument({ 'edit', count = i, addr = 'arg', mods = { tab = 1 } })
  end

  if vim.bo.filetype == 'gitcommit' then
    vim.api.nvim_create_autocmd('QuitPre', {
      buffer = vim.api.nvim_get_current_buf(),
      once = true,
      callback = function()
        local id = vim.fn.sockconnect('pipe', address, { rpc = true })
        vim.rpcnotify(id, 'nvim_exec_lua', 'vim.cmd.qall({ bang = true })', {})
        vim.fn.chanclose(id)
      end,
    })
    return true
  end

  vim.cmd('%argdelete')
end

---@param id integer
---@param code string
local function send(id, code)
  local result = vim.rpcrequest(id, 'nvim_exec_lua', code, {})
  if not result then
    vim.cmd.quitall({ bang = true })
  end
  vim.fn.chanclose(id)
  while true do
    vim.cmd.sleep(1)
  end
end

local function start()
  local address = os.getenv('NVIM')
  if not address then
    return
  end

  local args = vim.fn.argv()
  local cwd = vim.loop.cwd()
  local id = vim.fn.sockconnect('pipe', address, { rpc = true })
  if vim.wo.diff and #args <= 2 then
    local code = string.format('_G.diff(%s, %s)', vim.inspect(args), vim.inspect(cwd))
    send(id, code)
    return
  end

  if #args == 0 then
    vim.api.nvim_create_autocmd('StdinReadPost', {
      group = vim.api.nvim_create_augroup('unnest', {}),
      callback = function()
        local lines = vim.fn.getline(1, '$')
        local ft = vim.bo.filetype
        local code = string.format('_G.stdin(%s, %s)', vim.inspect(lines), vim.inspect(ft))
        send(id, code)
      end,
    })
    return
  end

  if #args > 0 then
    local code = string.format(
      '_G.args(%s, %s, %s)',
      vim.inspect(args),
      vim.inspect(cwd),
      vim.inspect(vim.v.servername)
    )
    send(id, code)
    return
  end
end

start()
