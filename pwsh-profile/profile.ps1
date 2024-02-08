Import-Module -Name Terminal-Icons
Import-Module git-aliases -DisableNameChecking

Invoke-Expression (& { (zoxide init powershell | Out-String) })
Invoke-Expression (& { (starship init powershell | Out-String) })
Invoke-Expression (& { (als init powershell | Out-String) })
