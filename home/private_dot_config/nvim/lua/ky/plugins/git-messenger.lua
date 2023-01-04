return {
  'rhysd/git-messenger.vim',
  keys = {
    { '<LocalLeader>gm', '<Plug>(git-messenger)' },
  },
  init = function()
    vim.g.git_messenger_floating_win_opts = { border = require('ky.ui').border }
    vim.g.git_messenger_include_diff = 'current'
    vim.g.git_messenger_popup_content_margins = false

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'gitmessengerpopup',
      callback = function()
        vim.opt_local.winbar = nil
      end,
    })
  end,
}