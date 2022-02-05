require('harpoon').setup {
  global_settings = {
    enter_on_sendcmd = true,
  },
  projects = {
    ['$XDG_DATA_HOME/chezmoi'] = {
      term = {
        cmds = {
          'asdf uninstall neovim nightly && asdf install neovim nightly',
          'asdf update --head',
          'asdf plugin-update --all',
        },
      },
    },
  },
}

local map = vim.keymap.set

map('n', [[<C-\>]], function()
  require('harpoon.term').gotoTerminal {
    idx = vim.v.count1,
    create_with = 'terminal',
  }
end)
map('n', '<M-a>', function()
  require('harpoon.mark').add_file()
  vim.notify(string.format('harpoon.mark: mark added'), vim.log.levels.INFO, { title = 'harpoon' })
end)
map('n', '<M-u>', require('harpoon.ui').toggle_quick_menu)
map('n', '<M-c>', require('harpoon.cmd-ui').toggle_quick_menu)
map('n', '<M-n>', function()
  require('harpoon.ui').nav_file(vim.v.count1)
end)
for i = 1, 5 do
  map('n', string.format('<M-%s>', i), function()
    require('harpoon.term').sendCommand(vim.v.count1, i)
  end)
end
