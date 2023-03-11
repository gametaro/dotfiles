local sessionfile = 'Session.vim'

local function load()
  vim.cmd.source({ sessionfile, mods = { silent = true, emsg_silent = true } })
end

local function save()
  vim.cmd.mksession({ bang = true })
end

local function autosave()
  local timer = vim.loop.new_timer()
  if timer then
    timer:start(0, 60000, vim.schedule_wrap(save))
  end
end

local group = vim.api.nvim_create_augroup('session', {})

vim.api.nvim_create_autocmd('VimEnter', {
  group = group,
  nested = true,
  callback = function()
    if vim.fn.argc(-1) == 0 and vim.loop.fs_stat(sessionfile) then
      load()
      autosave()
    end
  end,
})

vim.api.nvim_create_autocmd('VimLeavePre', {
  group = group,
  callback = save,
})
