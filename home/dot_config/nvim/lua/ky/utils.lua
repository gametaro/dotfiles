local M = {}

function _G.P(...)
  print(vim.inspect(...))
end

---check whether running neovim version is nightly or not
---check if the version of the running neovim is nightly
---@return boolean
function M.is_nightly()
  return vim.fn.has 'nvim-0.7' > 0
end

--toggle quickfix window
--@return any
function M.toggle_quickfix()
  return vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd 'cclose' or vim.cmd 'botright copen'
end

---go to quickfix window
---@return any
function M.goto_quickfix()
  local winid = vim.fn.getqflist({ winid = 0 }).winid
  vim.cmd 'cwindow'
  return winid ~= 0 and vim.fn.win_gotoid(winid)
end

---go to loclist window
---@return any
function M.goto_loclist()
  local winid = vim.fn.getloclist({ winid = 0 }).winid
  vim.cmd 'lwindow'
  return winid ~= 0 and vim.fn.win_gotoid(winid)
end

---check if the current buffer can be saved
---@return boolean
function M.can_save()
  return vim.bo.buftype == '' and vim.bo.filetype ~= '' and vim.bo.modifiable
end

---check nvim is running on headless mode
---@return boolean
function M.not_headless()
  return #vim.api.nvim_list_uis() > 0
end

---Searches process tree for a process having a name in the `names` list.
---Limited breadth/depth.
---@param rootpid number
---@param names list
---@param acc number
---@return boolean
-- @see https://github.com/justinmk/config/blob/master/.config/nvim/init.vim
function M.find_proc_in_tree(rootpid, names, acc)
  if acc > 9 or not vim.fn.exists '*nvim_get_proc' then
    return false
  end
  local p = vim.api.nvim_get_proc(rootpid)
  if vim.fn.empty(p) ~= 1 and vim.tbl_contains(names, p.name) then
    return true
  end
  local ids = vim.api.nvim_get_proc_children(rootpid)
  for _, id in ipairs(ids) do
    if M.find_proc_in_tree(id, names, 1 + acc) then
      return true
    end
  end
  return false
end

return M
