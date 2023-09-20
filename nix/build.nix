{ pkgs ? import <nixpkgs> {}, ... }:
{
  "7zip" = pkgs.callPackage ./7zip.nix {};
}
