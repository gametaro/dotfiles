vim.lsp.start({
  cmd = { 'lua-language-server' },
  root_names = { '.luarc.json' },
})

vim.keymap.set('n', 'K', function()
  local cword = vim.fn.expand('<cWORD>')
  local subject = string.match(cword, '|(%S-)|')
  if subject then
    vim.cmd.help(subject)
    return
  end
  vim.lsp.buf.hover()
end, { buffer = true, desc = 'Hover' })

require('nvim-surround').buffer_setup({
  surrounds = {
    ['f'] = {
      add = function()
        local result = require('nvim-surround.config').get_input('Enter the function name: ')
        if result then
          return { { result .. '(' }, { ')' } }
        end
      end,
    },
    ['F'] = {
      add = function()
        return { { 'function() ' }, { ' end' } }
      end,
    },
    ['p'] = {
      add = { 'vim.pretty_print(', ')' },
      find = 'vim%.pretty_print%b()',
      delete = '^(vim%.pretty_print%()().-(%))()$',
      change = {
        target = '^(vim%.pretty_print%()().-(%))()$',
      },
    },
  },
})
