Add-Content -Path /etc/nix/nix.conf -Value "substituters = https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://cache.nixos.org"
Add-Content -Path /etc/nix/nix.conf -Value "experimental-features = nix-command flakes"

# Restart nix daemon
if ($IsLinux) {
  sudo systemctl restart nix-daemon.service
} elseif ($IsMacOS) {
  sudo launchctl stop org.nixos.nix-daemon
  sudo launchctl start org.nixos.nix-daemon
}
