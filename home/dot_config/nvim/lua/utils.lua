local M = {}

function _G.dump(...)
  print(vim.inspect(...))
end

function M.is_nightly()
  return vim.fn.has 'nvim-0.7' > 0
end

function M.toggle_qf()
  return vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd 'cclose' or vim.cmd 'botright copen'
end

function M.goto_qf()
  local winid = vim.fn.getqflist({ winid = 0 }).winid
  vim.cmd 'cwindow'
  return winid ~= 0 and vim.fn.win_gotoid(winid)
end

function M.goto_loclist()
  local winid = vim.fn.getloclist({ winid = 0 }).winid
  vim.cmd 'lwindow'
  return winid ~= 0 and vim.fn.win_gotoid(winid)
end

function M.can_save()
  return vim.bo.buftype == '' and vim.bo.filetype ~= '' and vim.bo.modifiable
end

function M.highlight_under_cursor()
  local synID = vim.fn.synID(vim.fn.line '.', vim.fn.col '.', 1)
  local synIDattr = vim.fn.synIDattr(synID, 'name')
  vim.cmd(string.format('verbose highlight %s', synIDattr))
end

function M.not_headless()
  return #vim.api.nvim_list_uis() > 0
end

return M
