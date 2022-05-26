-- Inspired by
-- 1. vim-exjumplist
-- 2. vim-EnhancedJumps
-- 3. bufjump.nvim

local opts = {
  ignore_filetype = { 'gitcommit', 'gitrebase' },
  ignore_buftype = { 'terminal', 'nofile' },
}

local jump = function(count, forward)
  count = vim.F.if_nil(count, 1)
  forward = vim.F.if_nil(forward, true)
  vim.cmd('execute "normal! ' .. tostring(count) .. (forward and [[\<c-i>"]] or [[\<c-o>"]]))
end

local should_jump = function(bufnr)
  return vim.api.nvim_buf_is_valid(bufnr)
    and not vim.tbl_contains(opts.ignore_buftype, vim.api.nvim_buf_get_option(bufnr, 'buftype'))
    and not vim.tbl_contains(opts.ignore_filetype, vim.api.nvim_buf_get_option(bufnr, 'filetype'))
end

local backward = function()
  local jumplist, curpos = unpack(vim.fn.getjumplist())
  if #jumplist == 0 then
    return
  end

  curpos = curpos + 1
  local curbufnr = vim.api.nvim_get_current_buf()

  local dstpos
  for i = curpos - 1, 1, -1 do
    if jumplist[i].bufnr ~= curbufnr and should_jump(jumplist[i].bufnr) then
      dstpos = i
      break
    end
  end

  if dstpos ~= nil then
    jump((curpos + 1) - dstpos, false)
  end
end

local forward = function()
  local jumplist, curpos = unpack(vim.fn.getjumplist())
  if #jumplist == 0 or #jumplist == curpos then
    return
  end

  curpos = curpos + 1
  local curbufnr = vim.api.nvim_get_current_buf()

  local dstpos
  for i = curpos + 1, #jumplist do
    if jumplist[i].bufnr ~= curbufnr and should_jump(jumplist[i].bufnr) then
      dstpos = i
      break
    end
  end

  if dstpos ~= nil then
    jump(dstpos - curpos)
  end
end

vim.keymap.set('n', '<LocalLeader><C-i>', forward)
vim.keymap.set('n', '<LocalLeader><C-o>', backward)
