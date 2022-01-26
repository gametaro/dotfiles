using namespace System.Management.Automation
using namespace System.Management.Automation.Language

$ENV:XDG_CONFIG_HOME = "$HOME\.config"
$ENV:XDG_DATA_HOME = "$HOME\.local\share"
$ENV:XDG_CACHE_HOME = "$HOME\.cache"

$ENV:STARSHIP_CONFIG = "${ENV:XDG_CONFIG_HOME}\starship\starship.toml"
$ENV:RIPGREP_CONFIG_PATH = "${ENV:XDG_CONFIG_HOME}\ripgrep\config"

$ENV:Path += ";$HOME\bin"

if (Get-Command nvim -Type Application -ErrorAction SilentlyContinue)
{
  $ENV:EDITOR = 'nvim'
}

Set-Alias -Name g -Value git
Set-Alias -Name v -Value nvim

$PSReadlineOptions = @{
  BellStyle = "None"
  EditMode = "Emacs"
  HistoryNoDuplicates = $true
  HistorySearchCursorMovesToEnd = $true
}
Set-PSReadlineOption @PSReadlineOptions

Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

$PSReadlineVersion = (Get-Module PSReadLine).version
if ($PSReadlineVersion -ge '2.1.0')
{
  Set-PSReadLineOption -PredictionSource History
  Set-PSReadLineKeyHandler -Key Ctrl+p -Function HistorySearchBackward
  Set-PSReadLineKeyHandler -Key Ctrl+n -Function HistorySearchForward
}

if ((Get-Module psreadline).Version -gt 2.1.99 -and (Get-Command 'Enable-AzPredictor' -ErrorAction SilentlyContinue))
{
  Enable-AzPredictor
}

if (Get-Command zoxide -Type Application -ErrorAction SilentlyContinue)
{
  Invoke-Expression (& {
      $hook = if ($PSVersionTable.PSVersion.Major -lt 6)
      {
        'prompt'
      } else
      {
        'pwd'
      }
    (zoxide init --hook $hook powershell | Out-String)
    })
}

if (Get-Command starship -Type Application -ErrorAction SilentlyContinue)
{
  Invoke-Expression (&starship init powershell)
}
