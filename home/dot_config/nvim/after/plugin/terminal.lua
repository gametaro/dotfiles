local M = {}
local terminals = {}

local function create()
  local bufnr = vim.api.nvim_get_current_buf()

  vim.cmd('terminal')
  local buf_id = vim.api.nvim_get_current_buf()
  local term_id = vim.b.terminal_job_id
  if term_id == nil then
    return nil
  end

  -- Make sure the term buffer has "hidden" set so it doesn't get thrown
  -- away and cause an error
  vim.api.nvim_buf_set_option(buf_id, 'bufhidden', 'hide')

  -- Resets the buffer back to the old one
  vim.api.nvim_set_current_buf(bufnr)
  return buf_id, term_id
end

local function find(args)
  local term_handle = terminals[args.idx]
  if not term_handle or not vim.api.nvim_buf_is_valid(term_handle.buf_id) then
    local buf_id, term_id = create(args.create_with)
    if buf_id == nil then
      error('Failed to find and create terminal.')
      return
    end

    term_handle = {
      buf_id = buf_id,
      term_id = term_id,
    }
    terminals[args.idx] = term_handle
  end
  return term_handle
end

function M.go(idx)
  local term_handle = find(idx)

  vim.api.nvim_set_current_buf(term_handle.buf_id)
end

function M.clear_all()
  for _, term in ipairs(terminals) do
    vim.api.nvim_buf_delete(term.buf_id, { force = true })
  end
  terminals = {}
end

function M.valid_index(idx)
  if idx == nil or idx > M.get_length() or idx <= 0 then
    return false
  end
  return true
end

return M
