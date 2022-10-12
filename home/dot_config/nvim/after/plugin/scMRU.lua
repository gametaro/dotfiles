local ok = prequire('mru') and prequire('telescope')
if not ok then
  return
end

local mru = require('mru')
vim.keymap.set('n', '<LocalLeader><LocalLeader>', function()
  mru.display_cache(require('telescope.themes').get_dropdown({ previewer = false }))
end)
vim.keymap.set('n', '<LocalLeader>.', function()
  mru.display_cache(
    vim.tbl_extend(
      'keep',
      { algorithm = 'mfu' },
      require('telescope.themes').get_dropdown({ previewer = false })
    )
  )
end)
vim.keymap.set('n', '<LocalLeader>/', function()
  mru.display_repos(require('telescope.themes').get_dropdown({ previewer = false }))
end)
