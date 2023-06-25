#!/bin/zsh

# Ensure nix has been installed
nix-env -iA nixpkgs.openssl \
  nixpkgs.ripgrep \
  nixpkgs.fd \
  nixpkgs.htop \
  nixpkgs.neovim \
  nixpkgs.powershell \
  nixpkgs.tealdeer \
  nixpkgs.tokei \
  nixpkgs.zoxide \
  nixpkgs.jq \
  nixpkgs.gnupg \
  nixpkgs.delta \
  nixpkgs.jless \
  nixpkgs.tree \
  nixpkgs.du-dust \
  nixpkgs.bat \
  nixpkgs.rustup \
  nixpkgs.exa
