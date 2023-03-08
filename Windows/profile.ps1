Import-Module -Name Terminal-Icons
Import-Module git-aliases -DisableNameChecking

Import-Module posh-git
oh-my-posh init pwsh -c (Join-Path $env:LOCALAPPDATA "Programs" "oh-my-posh" "themes" "star.omp.json") | Invoke-Expression


Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadlineoption -PredictionViewStyle ListView
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

Set-Alias vi nvim
Set-Alias vim nvim
Set-Alias y yarn
Set-Alias p pnpm

Invoke-Expression (& {
    $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
    (zoxide init --hook $hook powershell | Out-String)
})
