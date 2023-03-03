return {
  'stevearc/profile.nvim',
  init = function()
    local function toggle_profile()
      local prof = require('profile')
      if prof.is_recording() then
        prof.stop()
        vim.ui.input(
          { prompt = 'Save profile to: ', completion = 'file', default = 'profile.json' },
          function(filename)
            if filename then
              prof.export(filename)
              vim.notify(string.format('Wrote %s', filename))
            end
          end
        )
      else
        prof.start('*')
      end
    end
    vim.keymap.set('', '<f1>', toggle_profile)
  end,
}
