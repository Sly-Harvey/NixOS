{ pkgs, lib }:
let
  srcInfo = import ./source.nix;
in
pkgs.callPackage ./appimage.nix {
  inherit lib pkgs srcInfo;
}
