{ pkgs, ... }:
{
  tmux-sessionizer = pkgs.callPackage ./tmux-sessionizer.nix {};
  collect-garbage = pkgs.callPackage ./collect-garbage.nix {};
  driverinfo = pkgs.callPackage ./driverinfo.nix {};
  underwatt = pkgs.callPackage ./underwatt.nix {};
}
