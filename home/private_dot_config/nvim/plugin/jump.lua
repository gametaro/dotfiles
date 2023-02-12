-- Inspired by
-- 1. vim-exjumplist
-- 2. vim-EnhancedJumps
-- 3. bufjump.nvim

local api = vim.api
local fn = vim.fn

---@class jump.Options
---@field ignore_buftype? string[]
---@field ignore_filetype? string[]
---@field only_cwd? boolean
---@field forward? boolean
---@field is_local? boolean
---@field on_success? function
---@field on_error? function

---@class jumplist.Item
---@field bufnr integer
---@field col integer
---@field coladd integer
---@field filename string|nil
---@field lnum integer

---@param bufnr integer
---@param opts jump.Options
---@return boolean
local condition = function(bufnr, opts)
  if not api.nvim_buf_is_valid(bufnr) then
    return false
  end
  if
    opts.ignore_buftype
    and vim.tbl_contains(opts.ignore_buftype, api.nvim_buf_get_option(bufnr, 'buftype'))
  then
    return false
  end
  if
    opts.ignore_filetype
    and vim.tbl_contains(opts.ignore_filetype, api.nvim_buf_get_option(bufnr, 'filetype'))
  then
    return false
  end
  if opts.only_cwd and not string.find(api.nvim_buf_get_name(bufnr), vim.fn.getcwd(), 1, true) then
    return false
  end
  return true
end

---@type jump.Options
local defaults = {
  ignore_filetype = { 'gitcommit', 'gitrebase' },
  ignore_buftype = { 'terminal', 'help', 'quickfix', 'nofile' },
  only_cwd = false,
  on_success = function() end,
  on_error = function()
    vim.notify('No destination found')
  end,
}

---@param opts jump.Options
local jump = function(opts)
  opts = vim.tbl_extend('force', defaults, opts or {})
  ---@type jumplist.Item[], integer
  local jumplist, current_pos = unpack(fn.getjumplist())
  if vim.tbl_isempty(jumplist) then
    return
  end

  current_pos = current_pos + 1
  if current_pos == (opts.forward and #jumplist or 1) then
    return
  end

  local current_bufnr = api.nvim_get_current_buf()
  ---@type integer|nil, integer|nil, integer|nil, integer|nil
  local prev_bufnr, next_bufnr, target_bufnr, target_pos
  local from = opts.forward and (current_pos + 1) or (current_pos - 1)
  local to = opts.forward and #jumplist or 1
  local unit = opts.forward and 1 or -1
  for i = from, to, unit do
    prev_bufnr = target_bufnr
    target_bufnr = jumplist[i].bufnr
    -- next_bufnr = jumplist[i + 1].bufnr
    if opts.is_local and (target_bufnr == current_bufnr) or (target_bufnr ~= current_bufnr) then
      if condition(target_bufnr, opts) then
        target_pos = i
        break
      end
    end
  end

  if target_pos == nil then
    opts.on_error({
      prev_bufnr = prev_bufnr,
      next_bufnr = next_bufnr,
      target_bufnr = target_bufnr,
      target_pos = target_pos,
    })
    return
  end

  vim.cmd.execute(
    string.format(
      [["normal! %s%s"]],
      tostring(target_pos - current_pos),
      opts.forward and [[\<C-i>]] or [[\<C-o>]]
    )
  )

  opts.on_success({
    prev_bufnr = prev_bufnr,
    next_bufnr = next_bufnr,
    target_bufnr = target_bufnr,
    target_pos = target_pos,
  })
end

---@param jumplist jumplist.Item[]
---@return table
local toqflist = function(jumplist)
  return vim.tbl_map(function(j)
    local text = unpack(api.nvim_buf_get_lines(j.bufnr, j.lnum - 1, j.lnum, true))
    return { bufnr = j.bufnr, col = j.col, lnum = j.lnum, text = text }
  end, jumplist)
end

---@param opts { qf: boolean, open: boolean }
local setlist = function(opts)
  opts = opts or {}
  ---@type jumplist.Item[]
  local jumplist = unpack(fn.getjumplist())
  local items = toqflist(vim.tbl_filter(function(j)
    return api.nvim_buf_is_loaded(j.bufnr)
  end, jumplist))
  if opts.qf then
    fn.setqflist({}, ' ', { title = 'Jumplist', items = items })
  else
    fn.setloclist(0, {}, ' ', { title = 'Jumplist', items = items })
  end
  if opts.open then
    if opts.qf then
      vim.cmd.copen({ mods = { split = 'botright' } })
    else
      vim.cmd.lopen()
    end
  end
end

local setqflist = function(open)
  setlist({ qf = true, open = open })
end

local setloclist = function(open)
  setlist({ qf = false, open = open })
end

---@param opts? jump.Options
local forward = function(opts)
  opts = opts or {}
  opts.forward = true
  opts.is_local = false
  jump(opts)
end

---@param opts? jump.Options
local backward = function(opts)
  opts = opts or {}
  opts.forward = false
  opts.is_local = false
  jump(opts)
end

---@param opts? jump.Options
local forward_local = function(opts)
  opts = opts or {}
  opts.forward = true
  opts.is_local = true
  jump(opts)
end

---@param opts? jump.Options
local backward_local = function(opts)
  opts = opts or {}
  opts.forward = false
  opts.is_local = true
  jump(opts)
end

vim.keymap.set('n', '<M-i>', function()
  forward()
end, { desc = 'Goto newer file' })
vim.keymap.set('n', '<M-o>', function()
  backward()
end, { desc = 'Goto older file' })
vim.keymap.set('n', 'g<C-i>', function()
  forward_local()
end, { desc = 'Goto newer position' })
vim.keymap.set('n', 'g<C-o>', function()
  backward_local()
end, { desc = 'Goto older position' })
-- vim.keymap.set('n', '<Leader>jq', function()
--   setqflist(true)
-- end)
-- vim.keymap.set('n', '<Leader>jl', function()
--   setloclist(true)
-- end)
