local ok = prequire('session_manager')
if not ok then
  return
end

require('session_manager').setup({
  autosave_ignore_filetypes = { 'gitcommit', 'gitrebase' },
})
