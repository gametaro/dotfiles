vim.opt_local.isfname:append('@-@')

vim.g.lsp_start({
  name = 'ts',
  cmd = { 'typescript-language-server', '--stdio' },
  root_patterns = { 'tsconfig.json', 'package.json' },
})

require('nvim-surround').buffer_setup({
  surrounds = {
    ['$'] = {
      add = function()
        return {
          { '${' },
          { '}' },
        }
      end,
    },
    ['p'] = {
      add = { 'console.log(', ')' },
      find = 'console%.log%b()',
      delete = '^(console%.log%()().-(%))()$',
      change = {
        target = '^(console%.log%()().-(%))()$',
      },
    },
  },
})
