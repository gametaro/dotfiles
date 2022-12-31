local wezterm = require('wezterm')

local launch_menu = {}
local set_environment_variables = {}

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  table.insert(launch_menu, {
    label = 'PowerShell',
    args = { 'powershell.exe', '-NoLogo' },
  })

  table.insert(launch_menu, {
    label = 'Pwsh',
    args = { 'pwsh.exe', '-NoLogo' },
  })

  table.insert(launch_menu, {
    label = 'Ubuntu-20.04 (WSL)',
    args = { 'wsl.exe', '~', '--distribution', 'Ubuntu-20.04' },
  })

  -- Use OSC 7 as per the above example
  set_environment_variables['prompt'] =
    '$E]7;file://localhost/$P$E\\$E[32m$T$E[0m $E[35m$P$E[36m$_$G$E[0m '
  -- use a more ls-like output format for dir
  set_environment_variables['DIRCMD'] = '/d'
end

return {
  adjust_window_size_when_changing_font_size = false,
  set_environment_variables = set_environment_variables,
  selection_word_boundary = ' \t\n{}[]()"\'`.,;:',
  launch_menu = launch_menu,
  enable_tab_bar = true,
  font = wezterm.font({
    family = 'FiraCode NF',
    harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
  }),
  font_size = 8.0,
  color_scheme = 'nightfox',
  add_wsl_distributions_to_launch_menu = false,
  initial_rows = 30,
  initial_cols = 100,
  scrollback_lines = 10000,
  window_padding = {
    left = 2,
    right = 2,
    top = 0,
    bottom = 0,
  },
}
