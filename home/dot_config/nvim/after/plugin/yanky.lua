local ok = prequire('yanky')
if not ok then return end

local mapping = require('yanky.telescope.mapping')

require('yanky').setup {
  picker = {
    telescope = {
      mappings = {
        default = mapping.put('p'),
        i = {
          ['<C-p>'] = nil,
          ['<C-x>'] = mapping.delete(),
        },
        n = {
          p = mapping.put('p'),
          P = mapping.put('P'),
          x = mapping.delete(),
        },
      },
    },
  },
  system_clipboard = {
    sync_with_ring = false,
  },
  highlight = {
    on_put = true,
    on_yank = false,
    timer = 200,
  },
}
require('telescope').load_extension('yank_history')

vim.keymap.set({ 'n', 'x' }, 'p', '<Plug>(YankyPutAfter)')
vim.keymap.set({ 'n', 'x' }, 'P', '<Plug>(YankyPutBefore)')
vim.keymap.set({ 'n', 'x' }, 'gp', '<Plug>(YankyGPutAfter)')
vim.keymap.set({ 'n', 'x' }, 'gP', '<Plug>(YankyGPutBefore)')
vim.keymap.set('n', ']p', '<Plug>(YankyCycleForward)')
vim.keymap.set('n', '[p', '<Plug>(YankyCycleBackward)')
vim.keymap.set({ 'n', 'x' }, 'y', '<Plug>(YankyYank)')
vim.keymap.set('n', '<LocalLeader>fy', function()
  require('telescope').extensions.yank_history.yank_history {}
end)
