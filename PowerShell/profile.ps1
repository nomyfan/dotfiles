Import-Module -Name Terminal-Icons


Import-Module -Name z

Import-Module posh-git
oh-my-posh init pwsh -c "C:\Users\nomyfan\AppData\Local\Programs\oh-my-posh\themes\star.omp.json"  | Invoke-Expression


Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadlineoption -PredictionViewStyle ListView
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

Set-Alias g git
Set-Alias vi nvim
