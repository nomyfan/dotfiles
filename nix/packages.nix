{ pkgs ? import <nixpkgs> {}, ...}:
{
  inherit (pkgs)
    openssl
    ripgrep
    fd
    htop
    neovim
    powershell
    tealdeer
    tokei
    zoxide
    jq
    gnupg
    delta
    jless
    du-dust
    eza
    bat
    hyperfine
    starship
    xz
    _7zz
    tmux
    gh
    zig
    cmake
    pkg-config
    libllvm
    imagemagick
    zstd
    pstree
  ;
}
