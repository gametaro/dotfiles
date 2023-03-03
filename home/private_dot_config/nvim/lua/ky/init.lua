vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.g.nerd = false
vim.g.border = require('ky.ui').border.single
vim.g.max_line_count = 10000

require('ky.option')
require('ky.diagnostic')
require('ky.lsp')
require('ky.lazy')

local profile = vim.env.NVIM_PROFILE
if profile then
  require('profile').instrument_autocmds()
  if profile:lower():match('^start') then
    require('profile').start('*')
  else
    require('profile').instrument('*')
  end

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
end

vim.cmd.colorscheme('heine')
