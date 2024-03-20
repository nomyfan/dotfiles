Add-Content -Path /etc/nix/nix.conf -Value "substituters = https://mirror.sjtu.edu.cn/nix-channels/store https://cache.nixos.org/"

# Nix channels
nix-channel --add https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixpkgs-unstable nixpkgs
nix-channel --update

# Restart nix daemon
if ($IsLinux) {
  sudo systemctl restart nix-daemon.service
} elseif ($IsMacOS) {
  sudo launchctl stop org.nixos.nix-daemon
  sudo launchctl start org.nixos.nix-daemon
}
