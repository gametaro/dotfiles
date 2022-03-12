local M = {}

function _G.P(...)
  print(vim.inspect(...))
end

---check if the version of the running neovim is nightly
---@return boolean
function M.is_nightly()
  return vim.fn.has('nvim-0.7') > 0
end

---go to loclist window
---@return any
function M.goto_loclist()
  local winid = vim.fn.getloclist({ winid = 0 }).winid
  vim.cmd('lwindow')
  return winid ~= 0 and vim.fn.win_gotoid(winid)
end

---check if the current buffer can be saved
---@return boolean
function M.can_save()
  return vim.bo.buftype == '' and vim.bo.filetype ~= '' and vim.bo.modifiable
end

return M
