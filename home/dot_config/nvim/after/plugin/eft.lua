vim.keymap.set({ 'n', 'x', 'o' }, ':', '<Plug>(eft-repeat)')
for _, v in ipairs({ 'f', 'F', 't', 'T' }) do
  vim.keymap.set({ 'n', 'x', 'o' }, v, string.format('<Plug>(eft-%s-repeatable)', v))
end
