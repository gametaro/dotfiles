local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  print(vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  }))
end
vim.opt.runtimepath:prepend(lazypath)

require('lazy').setup('ky.plugins', {
  lockfile = vim.fs.normalize('$XDG_DATA_HOME/chezmoi/home/dot_config/nvim/lazy-lock.json'),
  checker = {
    enabled = true,
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
