vim.g.committia_hooks = {
  edit_open = function()
    vim.keymap.set('i', '<A-d>', '<Plug>(committia-scroll-diff-down-half)', { buffer = true })
    vim.keymap.set('i', '<A-u>', '<Plug>(committia-scroll-diff-up-half)', { buffer = true })
  end,
}
