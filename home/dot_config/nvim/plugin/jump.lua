-- Inspired by
-- 1. vim-exjumplist
-- 2. vim-EnhancedJumps
-- 3. bufjump.nvim

local opts = {
  ignore_filetype = { 'gitcommit', 'gitrebase' },
  ignore_buftype = { 'terminal', 'nofile' },
  on_success = function() end,
  on_error = function()
    vim.notify('No destination found')
  end,
}

local jump = function(count, forward)
  count = vim.F.if_nil(count, 1)
  forward = vim.F.if_nil(forward, true)
  vim.cmd('execute "normal! ' .. tostring(count) .. (forward and [[\<C-i>"]] or [[\<c-o>"]]))
end

local condition = function(bufnr)
  return vim.api.nvim_buf_is_valid(bufnr)
    and not vim.tbl_contains(opts.ignore_buftype, vim.api.nvim_buf_get_option(bufnr, 'buftype'))
    and not vim.tbl_contains(opts.ignore_filetype, vim.api.nvim_buf_get_option(bufnr, 'filetype'))
end

local backward = function(is_local, winnr, tabnr)
  winnr = winnr or vim.api.nvim_win_get_number(0)
  tabnr = tabnr or vim.api.nvim_tabpage_get_number(0)
  local jumplist, curpos = unpack(vim.fn.getjumplist(winnr, tabnr))
  if #jumplist == 0 or curpos == 0 then
    return
  end

  curpos = curpos + 1
  local curbufnr = vim.api.nvim_get_current_buf()

  local dstpos
  local dstbufnr
  for i = curpos - 1, 1, -1 do
    dstbufnr = jumplist[i].bufnr
    if (is_local and dstbufnr == curbufnr or dstbufnr ~= curbufnr) and condition(dstbufnr) then
      dstpos = i
      break
    end
  end

  if dstpos == nil then
    opts.on_error()
    return
  end

  jump(dstpos - curpos, false)
  opts.on_success()
end

local forward = function(is_local, winnr, tabnr)
  winnr = winnr or vim.api.nvim_win_get_number(0)
  tabnr = tabnr or vim.api.nvim_tabpage_get_number(0)
  local jumplist, curpos = unpack(vim.fn.getjumplist(winnr, tabnr))
  if #jumplist == 0 or #jumplist == curpos then
    return
  end

  curpos = curpos + 1
  local curbufnr = vim.api.nvim_get_current_buf()

  local dstpos
  local dstbufnr
  for i = curpos + 1, #jumplist do
    dstbufnr = jumplist[i].bufnr
    if (is_local and dstbufnr == curbufnr or dstbufnr ~= curbufnr) and condition(dstbufnr) then
      dstpos = i
      break
    end
  end

  if dstpos == nil then
    opts.on_error()
    return
  end

  jump(dstpos - curpos)
  opts.on_success()
end

vim.keymap.set('n', '<Leader><C-i>', function()
  forward(false)
end)
vim.keymap.set('n', '<Leader><C-o>', function()
  backward(false)
end)
vim.keymap.set('n', 'g<C-i>', function()
  forward(true)
end)
vim.keymap.set('n', 'g<C-o>', function()
  backward(true)
end)
