local mapping = require('yanky.telescope.mapping')

require('yanky').setup {
  ring = {
    history_length = 50,
  },
  picker = {
    telescope = {
      mappings = {
        default = mapping.put('p'),
        i = {
          ['<c-p>'] = nil,
          ['<c-k>'] = mapping.put('P'),
          ['<c-x>'] = mapping.delete(),
        },
        n = {
          p = mapping.put('p'),
          P = mapping.put('P'),
          d = mapping.delete(),
        },
      },
    },
  },
  highlight = {
    timer = 200,
  },
}
require('telescope').load_extension('yank_history')

vim.keymap.set({ 'n', 'x' }, 'p', '<Plug>(YankyPutAfter)')
vim.keymap.set({ 'n', 'x' }, 'P', '<Plug>(YankyPutBefore)')
vim.keymap.set({ 'n', 'x' }, 'gp', '<Plug>(YankyGPutAfter)')
vim.keymap.set({ 'n', 'x' }, 'gP', '<Plug>(YankyGPutBefore)')
vim.keymap.set('n', ']y', '<Plug>(YankyCycleForward)')
vim.keymap.set('n', '[y', '<Plug>(YankyCycleBackward)')
vim.keymap.set({ 'n', 'x' }, 'y', '<Plug>(YankyYank)')
vim.keymap.set('n', '<LocalLeader>fy', function()
  require('telescope').extensions.yank_history.yank_history {}
end)
