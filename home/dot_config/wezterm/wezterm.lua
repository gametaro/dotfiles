local wezterm = require 'wezterm'

local launch_menu = {}

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  table.insert(launch_menu, {
    label = 'PowerShell',
    args = { 'powershell.exe', '-NoLogo' },
  })

  table.insert(launch_menu, {
    label = 'Ubuntu-20.04 (WSL)',
    args = { 'wsl.exe', '~', '--distribution', 'Ubuntu-20.04' },
  })
end

return {
  unix_domains = {
    {
      name = 'unix',
    },
  },
  default_gui_startup_args = { 'connect', 'unix' },
  use_ime = true,
  enable_tab_bar = true,
  font = wezterm.font_with_fallback { 'FiraCode NF', 'Consolas' },
  font_size = 8.0,
  color_scheme = 'nightfox',
  launch_menu = launch_menu,
  add_wsl_distributions_to_launch_menu = false,
  initial_rows = 30,
  initial_cols = 100,
  scrollback_lines = 10000,
}
