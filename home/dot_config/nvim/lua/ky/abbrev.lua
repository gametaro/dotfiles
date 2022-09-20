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
  if vim.fn.getcmdtype() == ':' and vim.fn.getcmdline():match('^' .. cmd) then
    return match
  else
    return cmd
  end
end

-- lua
M.cabbrev('l', 'lua =')
M.cabbrev('lv', 'lua =vim.')
M.cabbrev('la', 'lua =vim.api.nvim_')
M.cabbrev('lf', 'lua =vim.fn.')
M.cabbrev('lr', "lua =require''''<Left>")

-- lsp
M.cabbrev('lsi', 'LspInfo')
M.cabbrev('lsr', 'LspRestart')

-- capture.vim
-- M.cabbrev('c', 'Capture')

return M
