local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  print(vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  }))
end
vim.opt.runtimepath:prepend(lazypath)

require('lazy').setup('ky.plugins', {
  defaults = {
    lazy = true,
  },
  ui = {
    size = { width = 0.9, height = 0.9 },
    border = vim.g.border,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        -- "gzip",
        'matchit',
        'matchparen',
        'netrwPlugin',
        'rplugin',
        -- "tarPlugin",
        'tohtml',
        'tutor',
        -- "zipPlugin",
      },
    },
  },
})

vim.keymap.set('n', '<Leader>p', '<Cmd>Lazy<CR>')
vim.api.nvim_create_autocmd('User', {
  pattern = { 'LazySync' },
  callback = function()
    vim.notify('LazySync finished!')
  end,
})
