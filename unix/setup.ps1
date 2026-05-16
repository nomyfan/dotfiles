$dirname = Get-Location

# Utils scripts
New-Item -ItemType SymbolicLink -Path (Join-Path $HOME .ss) -Value (Join-Path $dirname .. ss) -Force

# Alias config
New-Item -ItemType SymbolicLink -Path (Join-Path $HOME .config alias.toml) -Value (Join-Path $dirname .. alias.toml) -Force

# Starship config
New-Item -ItemType SymbolicLink -Path (Join-Path $HOME .config starship.toml) -Value (Join-Path $dirname .. starship.toml) -Force

# Atuin config
New-Item -ItemType SymbolicLink -Path (Join-Path $HOME .config atuin config.toml) -Value (Join-Path $dirname .. atuin.toml) -Force

# Ghostty config
$GhosttyConfigDir = Join-Path $HOME .config ghostty
$GhosttyThemesDir = Join-Path $GhosttyConfigDir themes
New-Item -ItemType Directory -Path $GhosttyThemesDir -Force
New-Item -ItemType SymbolicLink -Path (Join-Path $GhosttyConfigDir config) -Value (Join-Path $dirname .. ghostty) -Force
New-Item -ItemType SymbolicLink -Path (Join-Path $GhosttyThemesDir vellum-dark) -Value (Join-Path $dirname .. vellum-theme themes ghostty-dark) -Force
New-Item -ItemType SymbolicLink -Path (Join-Path $GhosttyThemesDir vellum-light) -Value (Join-Path $dirname .. vellum-theme themes ghostty-light) -Force

# Zed themes
$ZedThemesDir = Join-Path $HOME .config zed themes
New-Item -ItemType Directory -Path $ZedThemesDir -Force
New-Item -ItemType SymbolicLink -Path (Join-Path $ZedThemesDir zed-dark.json) -Value (Join-Path $dirname .. vellum-theme themes zed-dark.json) -Force
New-Item -ItemType SymbolicLink -Path (Join-Path $ZedThemesDir zed-light.json) -Value (Join-Path $dirname .. vellum-theme themes zed-light.json) -Force

# Tmux config
New-Item -ItemType SymbolicLink -Path (Join-Path $HOME .tmux.conf) -Value (Join-Path $dirname tmux.conf) -Force

# .zshrc
New-Item -ItemType SymbolicLink -Path (Join-Path $HOME .zshrc) -Value (Join-Path $dirname zshrc) -Force
