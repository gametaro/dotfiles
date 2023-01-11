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
  lockfile = vim.fs.normalize('$XDG_DATA_HOME/chezmoi/home/private_dot_config/nvim/lazy-lock.json'),
  checker = {
    enabled = false,
  },
  change_detection = {
    notify = false,
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

vim.keymap.set('n', '<LocalLeader>p', vim.cmd.Lazy)
vim.api.nvim_create_autocmd('User', {
  pattern = { 'LazySync' },
  callback = function()
    vim.notify('LazySync finished!')
  end,
})
