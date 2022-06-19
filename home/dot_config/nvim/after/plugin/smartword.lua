vim.api.nvim_create_autocmd('User', {
  pattern = 'JetpackVimSmartwordPost',
  callback = function()
    for _, v in ipairs { 'w', 'b', 'e', 'ge' } do
      vim.keymap.set(
        '',
        string.format('<Plug>(smartword-basic-%s)', v),
        string.format('<Plug>CamelCaseMotion_%s', v)
      )
      vim.keymap.set('', v, string.format('<Plug>(smartword-%s)', v))
    end
  end,
})
