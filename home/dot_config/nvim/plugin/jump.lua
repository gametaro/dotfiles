-- Inspired by
-- 1. vim-exjumplist
-- 2. vim-EnhancedJumps
-- 3. bufjump.nvim

local api = vim.api
local fn = vim.fn

local config = {
  ignore_filetype = { 'gitcommit', 'gitrebase' },
  ignore_buftype = { 'terminal', 'help', 'quickfix', 'nofile' },
  only_cwd = true,
  on_success = function() end,
  on_error = function()
    vim.notify('No destination found')
  end,
}

local condition = function(bufnr)
  if not api.nvim_buf_is_valid(bufnr) then
    return false
  end
  if
    config.ignore_buftype
    and vim.tbl_contains(config.ignore_buftype, api.nvim_buf_get_option(bufnr, 'buftype'))
  then
    return false
  end
  if
    config.ignore_filetype
    and vim.tbl_contains(config.ignore_filetype, api.nvim_buf_get_option(bufnr, 'filetype'))
  then
    return false
  end
  if config.only_cwd and not string.find(api.nvim_buf_get_name(bufnr), vim.loop.cwd(), 1, true) then
    return false
  end
  return true
end

local jump = function(opts)
  local jumplist, current_pos = unpack(fn.getjumplist())
  if vim.tbl_isempty(jumplist) then
    return
  end

  current_pos = current_pos + 1
  if current_pos == (opts.forward and #jumplist or 1) then
    return
  end

  local current_bufnr = api.nvim_get_current_buf()
  local target_pos
  local target_bufnr
  local from = opts.forward and (current_pos + 1) or (current_pos - 1)
  local to = opts.forward and #jumplist or 1
  local unit = opts.forward and 1 or -1
  for i = from, to, unit do
    target_bufnr = jumplist[i].bufnr
    if opts.is_local and (target_bufnr == current_bufnr) or (target_bufnr ~= current_bufnr) then
      if condition(target_bufnr) then
        target_pos = i
        break
      end
    end
  end

  if target_pos == nil then
    config.on_error(target_bufnr)
    return
  end

  vim.cmd(
    string.format(
      'execute "normal! %s%s"',
      tostring(target_pos - current_pos),
      (opts.forward and [[\<C-i>]] or [[\<C-o>]])
    )
  )

  config.on_success(target_bufnr)
end

local toqflist = function(jumplist)
  return vim.tbl_map(function(j)
    local text = unpack(api.nvim_buf_get_lines(j.bufnr, j.lnum - 1, j.lnum, true))
    return { bufnr = j.bufnr, col = j.col, lnum = j.lnum, text = text }
  end, jumplist)
end

local setlist = function(qf, open)
  local jumplist = unpack(fn.getjumplist())
  local items = toqflist(vim.tbl_filter(function(j)
    return api.nvim_buf_is_loaded(j.bufnr)
  end, jumplist))
  if qf then
    fn.setqflist({}, ' ', { title = 'Jumplist', items = items })
  else
    fn.setloclist(0, {}, ' ', { title = 'Jumplist', items = items })
  end
  if open then
    api.nvim_command(qf and 'botright copen' or 'lopen')
  end
end

local setqfflist = function(open)
  setlist(true, open)
end

local setloclist = function(open)
  setlist(false, open)
end

local forward = function(opts)
  opts = opts or {}
  opts.forward = true
  opts.is_local = false
  jump(opts)
end

local backward = function(opts)
  opts = opts or {}
  opts.forward = false
  opts.is_local = false
  jump(opts)
end

local forward_local = function(opts)
  opts = opts or {}
  opts.forward = true
  opts.is_local = true
  jump(opts)
end

local backward_local = function(opts)
  opts = opts or {}
  opts.forward = false
  opts.is_local = true
  jump(opts)
end

vim.keymap.set('n', '<Leader><C-i>', function()
  forward()
end)
vim.keymap.set('n', '<Leader><C-o>', function()
  backward()
end)
vim.keymap.set('n', 'g<C-i>', function()
  forward_local()
end)
vim.keymap.set('n', 'g<C-o>', function()
  backward_local()
end)
-- vim.keymap.set('n', '<Leader>jq', function()
--   setqfflist(true)
-- end)
-- vim.keymap.set('n', '<Leader>jl', function()
--   setloclist(true)
-- end)
