vim.g.committia_hooks = {
  edit_open = function(info)
    if info.vcs == 'git' and vim.fn.getline(1) == '' then vim.cmd('startinsert') end
    vim.keymap.set('i', '<A-d>', '<Plug>(committia-scroll-diff-down-half)', { buffer = true })
    vim.keymap.set('i', '<A-u>', '<Plug>(committia-scroll-diff-up-half)', { buffer = true })
  end,
}
