# Binary caches
mkdir -p $HOME/.nixpkgs
cp ./darwin-configuration.nix $HOME/.nixpkgs

echo "substituters = https://mirror.sjtu.edu.cn/nix-channels/store https://cache.nixos.org/" | sudo tee -a /etc/nix/nix.conf

# Nix channels
nix-channel --add https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixpkgs-unstable nixpkgs
nix-channel --update

# Restart nix daemon
sudo launchctl stop org.nixos.nix-daemon
sudo launchctl start org.nixos.nix-daemon

