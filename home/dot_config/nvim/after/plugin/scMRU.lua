vim.keymap.set('n', '<LocalLeader><LocalLeader>', function()
  require('mru').display_cache(require('telescope.themes').get_dropdown { previewer = false })
end)
vim.keymap.set('n', '<LocalLeader>.', function()
  require('mru').display_cache(
    vim.tbl_extend(
      'keep',
      { algorithm = 'mfu' },
      require('telescope.themes').get_dropdown { previewer = false }
    )
  )
end)
vim.keymap.set('n', '<LocalLeader>/', function()
  require('mru').display_repos(require('telescope.themes').get_dropdown { previewer = false })
end)
