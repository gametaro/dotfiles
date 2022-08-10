local ok = prequire('lsp_lines')
if not ok then
  return
end

require('lsp_lines').setup()

vim.keymap.set('', '<LocalLeader>l', require('lsp_lines').toggle, { desc = 'Toggle lsp_lines' })
