-- Inspired by
-- 1. vim-exjumplist
-- 2. vim-EnhancedJumps
-- 3. bufjump.nvim

local opts = {
  ignore_filetype = { 'gitcommit', 'gitrebase' },
  ignore_buftype = { 'terminal', 'nofile' },
}

local jump = function(count, forward)
  vim.cmd('execute "normal! ' .. tostring(count) .. (forward and [[\<c-i>"]] or [[\<c-o>"]]))
end

local should_jump = function(bufnr)
  return vim.api.nvim_buf_is_valid(bufnr)
    and not vim.tbl_contains(opts.ignore_buftype, vim.api.nvim_buf_get_option(bufnr, 'buftype'))
    and not vim.tbl_contains(opts.ignore_filetype, vim.api.nvim_buf_get_option(bufnr, 'filetype'))
end

local backward = function()
  local jumplist, last_pos = unpack(vim.fn.getjumplist())
  if #jumplist == 0 then
    return
  end

  local curbufnr = vim.api.nvim_get_current_buf()

  local index
  for i = (last_pos + 1) - 1, 1, -1 do
    if jumplist[i].bufnr ~= curbufnr and should_jump(jumplist[i].bufnr) then
      index = i
      break
    end
  end

  if index ~= nil then
    jump(last_pos + 1 - index, false)
  end
end

local forward = function()
  local jumplist, last_pos = unpack(vim.fn.getjumplist())
  if #jumplist == 0 or #jumplist == last_pos then
    return
  end

  local curbufnr = vim.api.nvim_get_current_buf()

  local index
  for i = (last_pos + 1) + 1, #jumplist do
    if jumplist[i].bufnr ~= curbufnr and should_jump(jumplist[i].bufnr) then
      index = i
      break
    end
  end

  if index ~= nil then
    jump(index - (last_pos + 1), true)
  end
end

vim.keymap.set('n', '<LocalLeader><C-i>', forward)
vim.keymap.set('n', '<LocalLeader><C-o>', backward)
