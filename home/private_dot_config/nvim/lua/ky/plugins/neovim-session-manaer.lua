return {
  'Shatur/neovim-session-manager',
  lazy = false,
  config = function()
    require('session_manager').setup({
      autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir,
      autosave_ignore_filetypes = { 'gitcommit', 'gitrebase' },
    })
  end,
}