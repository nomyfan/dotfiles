# Install packer
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# symlink nvim config
New-Item -ItemType SymbolicLink -Path (Join-Path $HOME .config nvim) -Value (Join-Path (Get-Location) .. nvim) -Force
