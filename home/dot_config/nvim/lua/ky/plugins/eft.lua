return {
  'hrsh7th/vim-eft',
  keys = {
    { 'f', mode = { 'n', 'x', 'o' } },
    { 't', mode = { 'n', 'x', 'o' } },
    { 'F', mode = { 'n', 'x', 'o' } },
    { 'T', mode = { 'n', 'x', 'o' } },
  },
  config = function()
    for _, v in ipairs({ 'f', 'F', 't', 'T' }) do
      vim.keymap.set({ 'n', 'x', 'o' }, v, string.format('<Plug>(eft-%s-repeatable)', v))
    end
  end,
}
