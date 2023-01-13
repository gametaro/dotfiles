return {
  'gbprod/yanky.nvim',
  keys = {
    { 'p', '<Plug>(YankyPutAfter)', mode = { 'n', 'x' } },
    { 'P', '<Plug>(YankyPutBefore)', mode = { 'n', 'x' } },
    { 'gp', '<Plug>(YankyGPutAfter)', mode = { 'n', 'x' } },
    { 'gP', '<Plug>(YankyGPutBefore)', mode = { 'n', 'x' } },
    { ']y', '<Plug>(YankyCycleForward)' },
    { '[y', '<Plug>(YankyCycleBackward)' },
    { 'y', '<Plug>(YankyYank)', mode = { 'n', 'x' } },
    { ']p', '<Plug>(YankyPutIndentAfterLinewise)', mode = { 'n', 'x' } },
    { '[p', '<Plug>(YankyPutIndentBeforeLinewise)', mode = { 'n', 'x' } },
    { ']P', '<Plug>(YankyPutIndentAfterLinewise)', mode = { 'n', 'x' } },
    { '[P', '<Plug>(YankyPutIndentBeforeLinewise)', mode = { 'n', 'x' } },
    { '>p', '<Plug>(YankyPutIndentAfterShiftRight)', mode = { 'n', 'x' } },
    { '<p', '<Plug>(YankyPutIndentAfterShiftLeft)', mode = { 'n', 'x' } },
    { '>P', '<Plug>(YankyPutIndentBeforeShiftRight)', mode = { 'n', 'x' } },
    { '<P', '<Plug>(YankyPutIndentBeforeShiftLeft)', mode = { 'n', 'x' } },
    { '=p', '<Plug>(YankyPutAfterFilter)', mode = { 'n', 'x' } },
    { '=P', '<Plug>(YankyPutBeforeFilter)', mode = { 'n', 'x' } },
  },
  config = function()
    require('yanky').setup({
      system_clipboard = {
        sync_with_ring = false,
      },
      highlight = {
        on_put = true,
        on_yank = false,
        timer = 200,
      },
    })
  end,
}
