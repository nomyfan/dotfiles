#!/bin/zsh

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
nix-env -iA nixpkgs.gnupg
nix-env -iA nixpkgs.delta
nix-env -iA nixpkgs.jless
nix-env -iA nixpkgs.tree

