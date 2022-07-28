vim.g.committia_hooks = {
  edit_open = function(info)
    if info.vcs == 'git' and vim.api.nvim_get_current_line() == '' then vim.cmd.startinsert() end
    vim.keymap.set(
      'i',
      '<C-f>',
      '<Plug>(committia-scroll-diff-down-half)',
      { buffer = info.edit_bufnr }
    )
    vim.keymap.set(
      'i',
      '<C-b>',
      '<Plug>(committia-scroll-diff-up-half)',
      { buffer = info.edit_bufnr }
    )
  end,
}
