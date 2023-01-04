return {
  'psliwka/vim-dirtytalk',
  build = ':DirtytalkUpdate',
  init = function()
    vim.opt.rtp:prepend(vim.fn.stdpath('data') .. '/site')
    vim.opt.spelllang:append('programming')
  end,
}
