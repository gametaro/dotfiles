local M = {}

---@param lhs string
---@param rhs string
function M.cabbrev(lhs, rhs)
  vim.cmd.cnoreabbrev({
    '<expr>',
    lhs,
    string.format("v:lua.require'ky.abbrev'.command('%s', '%s')", lhs, rhs),
  })
end

---@param cmd string
---@param match string
---@return string
function M.command(cmd, match)
  return vim.fn.getcmdtype() == ':' and vim.fn.getcmdline():match('^' .. cmd) and match or cmd
end

return M
