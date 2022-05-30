-- Inspired by
-- 1. vim-exjumplist
-- 2. vim-EnhancedJumps
-- 3. bufjump.nvim

local config = {
  ignore_filetype = { 'gitcommit', 'gitrebase' },
  ignore_buftype = { 'terminal' },
  only_cwd = true,
  on_success = function() end,
  on_error = function()
    vim.notify('No destination found')
  end,
}

local condition = function(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end
  if
    config.ignore_buftype
    and vim.tbl_contains(config.ignore_buftype, vim.api.nvim_buf_get_option(bufnr, 'buftype'))
  then
    return false
  end
  if
    config.ignore_filetype
    and vim.tbl_contains(config.ignore_filetype, vim.api.nvim_buf_get_option(bufnr, 'filetype'))
  then
    return false
  end
  if
    config.only_cwd and not string.find(vim.api.nvim_buf_get_name(bufnr), vim.loop.cwd(), 1, true)
  then
    return false
  end
  return true
end

local get_jumplist = function()
  local winnr = vim.api.nvim_win_get_number(0)
  local tabnr = vim.api.nvim_tabpage_get_number(0)
  return unpack(vim.fn.getjumplist(winnr, tabnr))
end

local get_pos = function(opts)
  local curbufnr = vim.api.nvim_get_current_buf()

  local dstpos
  local dstbufnr
  local from = opts.forward and (opts.curpos + 1) or (opts.curpos - 1)
  local to = opts.forward and #opts.jumplist or 1
  local unit = opts.forward and 1 or -1
  for i = from, to, unit do
    dstbufnr = opts.jumplist[i].bufnr
    if opts.is_local and (dstbufnr == curbufnr) or (dstbufnr ~= curbufnr) then
      if condition(dstbufnr) then
        dstpos = i
        break
      end
    end
  end

  return dstpos, dstbufnr
end

local jump = function(is_local, forward)
  local jumplist, curpos = get_jumplist()
  if #jumplist == 0 then
    return
  end

  curpos = curpos + 1
  if curpos == (forward and #jumplist or 1) then
    return
  end

  local dstpos = get_pos {
    is_local = is_local,
    curpos = curpos,
    forward = forward,
    jumplist = jumplist,
  }
  if not dstpos then
    config.on_error()
    return
  end

  vim.cmd(
    string.format(
      'execute "normal! %s%s"',
      tostring(dstpos - curpos),
      (forward and [[\<C-i>]] or [[\<c-o>]])
    )
  )

  config.on_success()
end

local forward = function()
  jump(false, true)
end

local backward = function()
  jump(false, false)
end

local forward_local = function()
  jump(true, true)
end

local backward_local = function()
  jump(true, false)
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
