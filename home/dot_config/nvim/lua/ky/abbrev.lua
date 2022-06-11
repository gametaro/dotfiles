local M = {}

function M.cabbrev(lhs, rhs)
  local cmd = "cnoreabbrev <expr> %s v:lua.require'ky.abbrev'.command('%s', '%s')"

  vim.cmd(cmd:format(lhs, lhs, rhs))
end

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
M.cabbrev('rq', "lua =require''''<Left>")

-- lsp
M.cabbrev('lsi', 'LspInfo')
M.cabbrev('lsr', 'LspRestart')

-- capture.vim
M.cabbrev('c', 'Capture ')

return M
