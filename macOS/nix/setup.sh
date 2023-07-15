# Binary caches
mkdir -p $HOME/.nixpkgs
cp ./darwin-configuration.nix $HOME/.nixpkgs

# Nix channels
echo "substituters = https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://cache.nixos.org/" >> /etc/nix/nix.conf
nix-channel --add https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixpkgs-unstable nixpkgs
nix-channel --update

# Restart nix daemon
sudo launchctl stop org.nixos.nix-daemon
sudo launchctl start org.nixos.nix-daemon
