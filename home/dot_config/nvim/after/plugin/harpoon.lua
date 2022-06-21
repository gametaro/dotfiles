local ok = prequire('harpoon')
if not ok then
  return
end

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
    idx = vim.api.nvim_tabpage_get_number(vim.api.nvim_get_current_tabpage()),
  }
end, { desc = 'harpoon: create and go to terminal' })
map('n', '<M-a>', function()
  require('harpoon.mark').add_file()
  vim.notify('harpoon.mark: mark added', vim.log.levels.INFO, { title = 'harpoon' })
end, { desc = 'harpoon: add mark' })
map('n', '<M-t>u', require('harpoon.ui').toggle_quick_menu, { desc = 'harpoon: toggle quick menu' })
map(
  'n',
  '<M-t>c',
  require('harpoon.cmd-ui').toggle_quick_menu,
  { desc = 'harpoon: toggle quick cmd menu' }
)
for i = 1, 5 do
  map('n', string.format('<M-%s>', i), function()
    require('harpoon.ui').nav_file(i)
  end, { desc = 'navigate to file' })
end
for i = 1, 5 do
  map('n', string.format('<M-c>%s', i), function()
    require('harpoon.term').gotoTerminal(vim.v.count1)
    require('harpoon.term').sendCommand(vim.v.count1, i)
  end, { desc = string.format('harpoon: go to terminal %s and execute command', i) })
end
