{ config, lib, pkgs, ... }:
{
  nix.binaryCaches = [ "https://mirror.sjtu.edu.cn/nix-channels/store" ];
}
