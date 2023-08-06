echo "substituters = https://mirror.sjtu.edu.cn/nix-channels/store https://cache.nixos.org/" >> /etc/nix/nix.conf
# Nix channels
nix-channel --add https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixpkgs-unstable nixpkgs
nix-channel --update

# Restart nix daemon
sudo systemctl restart nix-daemon.service
