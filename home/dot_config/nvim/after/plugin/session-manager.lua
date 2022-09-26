local ok = prequire('session_manager')
if not ok then
  return
end

require('session_manager').setup({
  autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir,
  autosave_ignore_filetypes = { 'gitcommit', 'gitrebase' },
})
