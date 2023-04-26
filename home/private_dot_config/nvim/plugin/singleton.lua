---@alias singleton.OpenType 'default'|'diff'|'stdin'

---@class singleton.Config
---@field public open table<singleton.OpenType, fun(data: string[]): nil>
local config = {
  open = {
    default = function(files)
      -- NOTE: no need for noautocmd to detect gitcommit
      vim.cmd.drop({ args = files, mods = { tab = 1, keepjumps = true } })
    end,
    diff = function(files)
      for i, file in ipairs(files) do
        if i == 1 then
          vim.cmd.tabnew({ file, mods = { keepjumps = true, noautocmd = true } })
        elseif i == 2 then
          vim.cmd.vsplit({ file, mods = { split = 'botright', keepjumps = true, noautocmd = true } })
        elseif i == 3 then
          vim.cmd.split({ file, mods = { split = 'botright', keepjumps = true, noautocmd = true } })
        end
        vim.cmd.diffthis()
      end
    end,
    stdin = function(lines)
      -- TODO: vim.cmd can't parse `$`?
      vim.cmd('keepjumps noautocmd $tabnew')
      vim.api.nvim_buf_set_name(0, 'singleton_' .. math.random())
      vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
      vim.bo.readonly = true
      vim.bo.modified = false
      vim.bo.bufhidden = 'wipe'
      vim.bo.buflisted = false
      vim.bo.buftype = 'nofile'
      vim.cmd.filetype('detect')
      vim.cmd.redraw()

      vim.keymap.set('n', 'q', function()
        vim.cmd.quit({ bang = true })
      end, { buffer = true, nowait = true })
    end,
  },
}

---@param file string
---@param cwd string
---@return string
local function fullpath(file, cwd)
  return vim.fs.normalize(vim.loop.fs_realpath(file) or cwd .. '/' .. file)
end

---@param data string[]
---@param type? singleton.OpenType
local function open(data, type)
  type = type or 'default'
  config.open[type](data)
end

---@param address string
local function close(address)
  local ok, chan = pcall(vim.fn.sockconnect, unpack({ 'pipe', address, { rpc = true } }))
  if not ok then
    vim.notify(chan, vim.log.levels.WARN)
    return
  end
  vim.rpcnotify(chan, 'nvim_exec_lua', 'vim.cmd.qall({ bang = true })', {})
  vim.fn.chanclose(chan)
end

---@param args string[]
---@param cwd string
---@param address string
_G.default = function(args, cwd, address)
  local files = vim.iter.map(function(arg)
    return fullpath(arg, cwd)
  end, args)
  open(files)

  if vim.bo.filetype == 'gitcommit' then
    vim.api.nvim_create_autocmd({ 'QuitPre', 'BufUnload' }, {
      buffer = vim.api.nvim_get_current_buf(),
      once = true,
      callback = function()
        close(address)
      end,
    })
    return true
  end
end

---@param args string[]
---@param cwd string
_G.diff = function(args, cwd)
  local files = vim.iter.map(function(arg)
    return fullpath(arg, cwd)
  end, args)
  open(files, 'diff')
end

---@param lines string[]
_G.stdin = function(lines)
  open(lines, 'stdin')
end

local function wait()
  local interrupted = false
  while not interrupted do
    local ok, msg = pcall(vim.fn.getchar)
    if not ok and msg == 'Keyboard interrupt' then
      interrupted = true
    end
  end
end

---@param chan integer
---@param code string
---@param ... unknown
local function send(chan, code, ...)
  local result = vim.rpcrequest(chan, 'nvim_exec_lua', code, { ... })
  if result == vim.NIL then
    vim.cmd.quitall({ bang = true })
  end
  vim.fn.chanclose(chan)
  wait()
end

local function start()
  local address = vim.env.NVIM
  if not address then
    return
  end

  local args = vim.fn.argv()
  local cwd = vim.loop.cwd()
  local ok, chan = pcall(vim.fn.sockconnect, unpack({ 'pipe', address, { rpc = true } }))
  if not ok then
    vim.notify(chan, vim.log.levels.WARN)
    return
  end

  -- diff
  if vim.wo.diff and #args <= 3 then
    local code = 'return _G.diff(...)'
    send(chan, code, args, cwd)
    return
  end

  -- stdin
  if #args == 0 then
    vim.api.nvim_create_autocmd('StdinReadPost', {
      group = vim.api.nvim_create_augroup('singleton', {}),
      callback = function(a)
        local lines = vim.api.nvim_buf_get_lines(a.buf, 0, -1, false)
        local code = 'return _G.stdin(...)'
        send(chan, code, lines)
      end,
    })
    return
  end

  -- default
  if #args > 0 then
    local code = 'return _G.default(...)'
    -- TODO: can remove servername?
    send(chan, code, args, cwd, vim.v.servername)
    return
  end
end

start()
