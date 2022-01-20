$ENV:XDG_CONFIG_HOME = "$HOME\.config"
$ENV:XDG_DATA_HOME = "$HOME\.local\share"
$ENV:STARSHIP_CONFIG = "$HOME\.config\starship\starship.toml"
$ENV:RIPGREP_CONFIG_PATH = "$HOME\.config\ripgrep\config"

Set-Alias -Name g -Value git
Set-Alias -Name v -Value nvim

Set-PSReadlineOption -EditMode Emacs -BellStyle None

Invoke-Expression (&starship init powershell)
