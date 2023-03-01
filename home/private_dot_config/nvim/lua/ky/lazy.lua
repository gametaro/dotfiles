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
    border = vim.g.border,
    icons = {
      cmd = '',
      config = '',
      event = '',
      ft = '',
      init = '',
      import = '',
      keys = '',
      lazy = '',
      loaded = '*',
      not_loaded = '-',
      plugin = '',
      runtime = '',
      source = '',
      start = '',
      task = '',
      list = {
        '',
        '',
        '',
        '',
      },
    },
  },
  change_detection = {
    enabled = false,
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
