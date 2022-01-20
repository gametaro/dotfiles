$ENV:XDG_CONFIG_HOME = "$HOME\.config"
$ENV:XDG_DATA_HOME = "$HOME\.local\share"
$ENV:STARSHIP_CONFIG = "$HOME\.config\starship\starship.toml"
$ENV:RIPGREP_CONFIG_PATH = "$HOME\.config\ripgrep\config"
$ENV:Path += ";$HOME\bin" # for chezmoi

Set-Alias -Name g -Value git
Set-Alias -Name v -Value nvim

$PSReadlineOptions = @{
  BellStyle = "None"
  EditMode = "Emacs"
  HistoryNoDuplicates = $true
  HistorySearchCursorMovesToEnd = $true
  PredictionSource = "History"
}
Set-PSReadlineOption @PSReadlineOptions

Invoke-Expression (&starship init powershell)
