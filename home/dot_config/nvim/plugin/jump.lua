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

---@param buf integer
---@param opts jump.Options
---@return boolean
local function condition(buf, opts)
  if not vim.api.nvim_buf_is_valid(buf) then
    return false
  end
  if not vim.api.nvim_buf_is_loaded(buf) then
    vim.fn.bufload(buf)
  end
  if opts.ignore_buftype and vim.tbl_contains(opts.ignore_buftype, vim.bo[buf].buftype) then
    return false
  end
  if opts.ignore_filetype and vim.tbl_contains(opts.ignore_filetype, vim.bo[buf].filetype) then
    return false
  end
  if
    opts.only_cwd and not string.find(vim.api.nvim_buf_get_name(buf), vim.fn.getcwd(), 1, true)
  then
    return false
  end
  return true
end

---@param key string
local function feed_keys(key)
  vim.api.nvim_feedkeys(vim.keycode(key), 'n', false)
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
local function jump(opts)
  opts = vim.tbl_extend('force', defaults, opts or {})
  ---@type jumplist.Item[], integer
  local jumplist, current_pos = unpack(vim.fn.getjumplist())
  if vim.tbl_isempty(jumplist) then
    return
  end

  current_pos = current_pos + 1
  if current_pos == (opts.forward and #jumplist or 1) then
    return
  end

  local current_buf = vim.api.nvim_get_current_buf()
  ---@type integer?, integer?, integer?, integer?
  local prev_buf, next_buf, target_buf, target_pos
  local from = opts.forward and (current_pos + 1) or (current_pos - 1)
  local to = opts.forward and #jumplist or 1
  local unit = opts.forward and 1 or -1
  for i = from, to, unit do
    prev_buf = target_buf
    target_buf = jumplist[i].bufnr
    -- next_buf = jumplist[i + 1].bufnr
    if opts.is_local and (target_buf == current_buf) or (target_buf ~= current_buf) then
      if condition(target_buf, opts) then
        target_pos = i
        break
      end
    end
  end

  if target_pos == nil then
    opts.on_error({
      prev_buf = prev_buf,
      next_buf = next_buf,
      target_buf = target_buf,
      target_pos = target_pos,
    })
    return
  end

  feed_keys(string.format('%s%s', target_pos - current_pos, opts.forward and '<C-i>' or '<C-o>'))

  opts.on_success({
    prev_buf = prev_buf,
    next_buf = next_buf,
    target_buf = target_buf,
    target_pos = target_pos,
  })
end

---@param jumplist jumplist.Item[]
---@return table
local function toqflist(jumplist)
  return vim.iter.map(function(j)
    local text = unpack(vim.api.nvim_buf_get_lines(j.bufnr, j.lnum - 1, j.lnum, true))
    return { bufnr = j.bufnr, col = j.col, lnum = j.lnum, text = text }
  end, jumplist)
end

---@param opts { qf: boolean, open: boolean }
local function setlist(opts)
  opts = opts or {}
  ---@type jumplist.Item[]
  local jumplist = unpack(vim.fn.getjumplist())
  local items = toqflist(vim.iter.filter(function(j)
    return vim.api.nvim_buf_is_loaded(j.bufnr)
  end, jumplist))
  if opts.qf then
    vim.fn.setqflist({}, ' ', { title = 'Jumplist', items = items })
  else
    vim.fn.setloclist(0, {}, ' ', { title = 'Jumplist', items = items })
  end
  if opts.open then
    if opts.qf then
      vim.cmd.copen({ mods = { split = 'botright' } })
    else
      vim.cmd.lopen()
    end
  end
end

local function setqflist(open)
  setlist({ qf = true, open = open })
end

local function setloclist(open)
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

vim.keymap.set('n', '<M-i>', forward, { desc = 'Goto newer file' })
vim.keymap.set('n', '<M-o>', backward, { desc = 'Goto older file' })
vim.keymap.set('n', 'g<C-i>', forward_local, { desc = 'Goto newer position' })
vim.keymap.set('n', 'g<C-o>', backward_local, { desc = 'Goto older position' })
-- vim.keymap.set('n', '<Leader>jq', function()
--   setqflist(true)
-- end)
-- vim.keymap.set('n', '<Leader>jl', function()
--   setloclist(true)
-- end)
