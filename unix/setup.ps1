$dirname = Get-Location

# Utils scripts
New-Item -ItemType SymbolicLink -Path (Join-Path $HOME .ss) -Value (Join-Path $dirname .. ss) -Force

# Alias config
New-Item -ItemType SymbolicLink -Path (Join-Path $HOME .config alias.toml) -Value (Join-Path $dirname .. alias.toml) -Force

# Starship config
New-Item -ItemType SymbolicLink -Path (Join-Path $HOME .config starship.toml) -Value (Join-Path $dirname .. starship.toml) -Force

# Atuin config
New-Item -ItemType SymbolicLink -Path (Join-Path $HOME .config atuin config.toml) -Value (Join-Path $dirname .. atuin.toml) -Force

# Tmux config
New-Item -ItemType SymbolicLink -Path (Join-Path $HOME .tmux.conf) -Value (Join-Path $dirname tmux.conf) -Force

# .zshrc
New-Item -ItemType SymbolicLink -Path (Join-Path $HOME .zshrc) -Value (Join-Path $dirname zshrc) -Force
