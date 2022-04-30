$env:WINGET_PROXY_URL="http://127.0.0.1:7890"
winget install JanDeDobbeleer.OhMyPosh
Add-MpPreference -ExclusionProcess oh-my-posh.exe

Install-Module -Name Terminal-Icons -Repository PSGallery -Force
Install-Module posh-git -Scope CurrentUser -Force

Install-Module PSReadLine -Force -AllowPrerelease -SkipPublisherCheck
Install-Module -Name z -Force

Install-Module git-aliases -Scope CurrentUser -AllowClobber
