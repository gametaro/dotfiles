local M = {}

local opts = { noremap = true, silent = true }

-- Set some keybinds conditional on server capabilities
function M.setup(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  if client.resolved_capabilities.document_formatting then
    buf_set_keymap('n', '<A-f>', '<Cmd>lua vim.lsp.buf.formatting_sync()<CR>', opts)
    vim.cmd 'autocmd mine BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()'
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap('n', '<A-f>f', '<Cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
  end
end

return M
