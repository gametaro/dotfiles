local sessionfile = 'Session.vim'
local stdin = false

local function load()
  vim.cmd.source({ sessionfile, mods = { emsg_silent = true } })
end

local function save()
  vim.cmd.mksession({ bang = true })
end

---@param timeout? integer
local function autosave(timeout)
  timeout = timeout or 60000
  local timer = vim.loop.new_timer()
  if timer then
    timer:start(0, timeout, vim.schedule_wrap(save))
  end
end

local group = vim.api.nvim_create_augroup('session', {})

vim.api.nvim_create_autocmd('StdinReadPre', {
  group = group,
  callback = function()
    stdin = true
  end,
})

vim.api.nvim_create_autocmd('VimEnter', {
  group = group,
  nested = true,
  callback = function()
    if vim.fn.argc(-1) == 0 and not stdin and vim.loop.fs_stat(sessionfile) then
      load()
      autosave()
    end
  end,
})

vim.api.nvim_create_autocmd('VimLeavePre', {
  group = group,
  callback = function()
    if vim.fn.argc(-1) > 0 then
      vim.cmd('%argdelete')
    end
    save()
  end,
})
