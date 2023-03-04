#!/bin/zsh

# Install ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Ensure nix has been installed
nix-env -iA nixpkgs.ripgrep
nix-env -iA nixpkgs.fd
nix-env -iA nixpkgs.htop
nix-env -iA nixpkgs.neovim
nix-env -iA nixpkgs.powershell
nix-env -iA nixpkgs.tealdeer
nix-env -iA nixpkgs.tokei
nix-env -iA nixpkgs.zoxide
nix-env -iA nixpkgs.jq


# Copy dotfiles
cp ./.zshrc $HOME/.zshrc
