return {
  'hotwatermorning/auto-git-diff',
  config = function()
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('mine_auto_git_diff', {}),
      pattern = 'gitrebase',
      callback = function(a)
        vim.keymap.set(
          'n',
          '<C-l>',
          '<Plug>(auto_git_diff_scroll_manual_update)',
          { buffer = a.buf }
        )
        vim.keymap.set('n', '<C-d>', '<Plug>(auto_git_diff_scroll_down_half)', { buffer = a.buf })
        vim.keymap.set('n', '<C-u>', '<Plug>(auto_git_diff_scroll_up_half)', { buffer = a.buf })
      end,
    })
  end,
}
