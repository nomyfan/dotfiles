let pkgs = import <nixpkgs> {};
in
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
    tree
    du-dust
    rustup
    exa
    bat
    ;
}
