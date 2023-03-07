vim.opt_local.isfname:append('@-@')

vim.g.lsp_start({
  cmd = { 'typescript-language-server', '--stdio' },
  root_names = { 'tsconfig.json', 'package.json' },
  settings = {
    completions = {
      completeFunctionCalls = true,
    },
  },
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
