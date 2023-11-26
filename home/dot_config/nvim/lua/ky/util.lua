local M = {}

---check nvim is running on headless mode
---@return boolean
function M.headless()
  return #vim.api.nvim_list_uis() == 0
end

---@return boolean
function M.is_win()
  return vim.uv.os_uname().sysname:find('Windows') ~= nil
end

---searches process tree for a process having a name in the `names` list
---@param rootpid integer
---@param names table
---@param acc? integer
---@return boolean
---@see https://github.com/justinmk/config/blob/master/.config/nvim/init.vim
function M.find_proc_in_tree(rootpid, names, acc)
  acc = acc or 0
  if acc > 9 then
    return false
  end
  local p = vim.api.nvim_get_proc(rootpid)
  if p and vim.tbl_contains(names, p.name) then
    return true
  end
  local ids = vim.api.nvim_get_proc_children(rootpid)
  return vim.iter(ids):any(function(id)
    return M.find_proc_in_tree(id, names, 1 + acc)
  end)
end

---@return boolean
function M.is_git_repo()
  local root_dir
  for dir in vim.fs.parents(vim.api.nvim_buf_get_name(0)) do
    if vim.fn.isdirectory(dir .. '/.git') == 1 then
      root_dir = dir
      break
    end
  end
  return root_dir ~= nil
end

M.root_cache = {}

---@param names? string|string[]
---@return string?
function M.get_root_by_names(names)
  names = names or { '.git', '.svn' }
  local path = vim.api.nvim_buf_get_name(0)
  if path == '' then
    return
  end
  local dirname = vim.fs.dirname(path)
  if not dirname then
    return
  end

  local root = M.root_cache[dirname]
  if not root then
    root = vim.fs.dirname(vim.fs.find(names, { path = dirname, upward = true })[1])
    M.root_cache[dirname] = root
  end
  return root
end

---@param opts? { buffer?: integer, id?: integer, name?: string, ignore?: string[] }
---@return string?
function M.get_root_by_lsp(opts)
  opts = opts or {}
  local buffer = opts.buffer or vim.api.nvim_get_current_buf()
  local ignore = { 'null-ls' }

  local root_dir
  for _, client in ipairs(vim.lsp.get_clients({ id = opts.id, name = opts.name, bufnr = buffer })) do
    if
      -- vim.tbl_contains(client.config.filetypes or {}, vim.bo[buffer].filetype)
      not vim.tbl_contains(ignore, client.name)
    then
      root_dir = client.config.root_dir
      break
    end
  end

  return root_dir
end

return M
