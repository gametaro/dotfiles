local ok = prequire('lsp_lines')
if not ok then return end

require('lsp_lines').setup()

vim.keymap.set('', '<LocalLeader>l', function()
  require('lsp_lines').toggle()
end, { desc = 'Toggle lsp_lines' })
