local ok = prequire('gitlinker')
if not ok then
  return
end

for _, v in ipairs({ 'n', 'v' }) do
  vim.keymap.set(v, 'gb', function()
    require('gitlinker').get_buf_range_url(v, { action_callback = vim.fn['openbrowser#open'] })
  end)
  vim.keymap.set(v, '<LocalLeader>gy', function()
    require('gitlinker').get_buf_range_url(v)
  end)
end
vim.keymap.set('n', 'gB', function()
  require('gitlinker').get_repo_url({
    action_callback = vim.fn['openbrowser#open'],
  })
end)
vim.keymap.set('n', '<LocalLeader>gY', function()
  require('gitlinker').get_repo_url()
end)

require('gitlinker').setup({
  mappings = nil,
})
