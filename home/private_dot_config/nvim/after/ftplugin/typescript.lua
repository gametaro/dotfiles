vim.opt_local.isfname:append('@-@')

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
