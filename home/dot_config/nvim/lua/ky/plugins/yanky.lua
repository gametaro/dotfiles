return {
  'gbprod/yanky.nvim',
  dependencies = 'kkharji/sqlite.lua',
  event = 'VeryLazy',
  config = function()
    require('yanky').setup({
      ring = {
        storage = 'sqlite',
      },
      system_clipboard = {
        sync_with_ring = false,
      },
      highlight = {
        on_put = true,
        on_yank = false,
        timer = 200,
      },
    })

    vim.keymap.set({ 'n', 'x' }, 'p', '<Plug>(YankyPutAfter)')
    vim.keymap.set({ 'n', 'x' }, 'P', '<Plug>(YankyPutBefore)')
    vim.keymap.set({ 'n', 'x' }, 'gp', '<Plug>(YankyGPutAfter)')
    vim.keymap.set({ 'n', 'x' }, 'gP', '<Plug>(YankyGPutBefore)')
    vim.keymap.set('n', ']y', '<Plug>(YankyCycleForward)')
    vim.keymap.set('n', '[y', '<Plug>(YankyCycleBackward)')
    vim.keymap.set({ 'n', 'x' }, 'y', '<Plug>(YankyYank)')
    vim.keymap.set({ 'n', 'x' }, ']p', '<Plug>(YankyPutIndentAfterLinewise)')
    vim.keymap.set({ 'n', 'x' }, '[p', '<Plug>(YankyPutIndentBeforeLinewise)')
    vim.keymap.set({ 'n', 'x' }, ']P', '<Plug>(YankyPutIndentAfterLinewise)')
    vim.keymap.set({ 'n', 'x' }, '[P', '<Plug>(YankyPutIndentBeforeLinewise)')
    vim.keymap.set({ 'n', 'x' }, '>p', '<Plug>(YankyPutIndentAfterShiftRight)')
    vim.keymap.set({ 'n', 'x' }, '<p', '<Plug>(YankyPutIndentAfterShiftLeft)')
    vim.keymap.set({ 'n', 'x' }, '>P', '<Plug>(YankyPutIndentBeforeShiftRight)')
    vim.keymap.set({ 'n', 'x' }, '<P', '<Plug>(YankyPutIndentBeforeShiftLeft)')
    vim.keymap.set({ 'n', 'x' }, '=p', '<Plug>(YankyPutAfterFilter)')
    vim.keymap.set({ 'n', 'x' }, '=P', '<Plug>(YankyPutBeforeFilter)')
  end,
}
