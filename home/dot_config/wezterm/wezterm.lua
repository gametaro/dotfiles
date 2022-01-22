local wezterm = require 'wezterm'

local launch_menu = {}
local default_prog;
local set_environment_variables = {}

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  table.insert(launch_menu, {
    label = 'PowerShell',
    args = { 'powershell.exe', '-NoLogo' },
  })

  table.insert(launch_menu, {
    label = 'Ubuntu-20.04 (WSL)',
    args = { 'wsl.exe', '~', '--distribution', 'Ubuntu-20.04' },
  })

  -- Use OSC 7 as per the above example
  set_environment_variables["prompt"] = "$E]7;file://localhost/$P$E\\$E[32m$T$E[0m $E[35m$P$E[36m$_$G$E[0m "
  -- use a more ls-like output format for dir
  set_environment_variables["DIRCMD"] = "/d"
  -- And inject clink into the command prompt
  default_prog = {"cmd.exe", "/s", "/k", "%USERPROFILE%/scoop/shims/clink", "inject", "-q"}
end

return {
  unix_domains = {
    {
      name = 'unix',
    },
  },
  default_gui_startup_args = { 'connect', 'unix' },
  default_prog = default_prog,
  set_environment_variables = set_environment_variables,
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
