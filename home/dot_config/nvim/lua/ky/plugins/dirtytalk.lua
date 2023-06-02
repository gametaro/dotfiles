return {
  'psliwka/vim-dirtytalk',
  build = ':DirtytalkUpdate',
  cmd = 'DirtytalkUpdate',
  init = function()
    vim.opt.rtp:append(vim.fn.stdpath('data') .. '/site')
    vim.opt.spelllang:append('programming')
  end,
}
