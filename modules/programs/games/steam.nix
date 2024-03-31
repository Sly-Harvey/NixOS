{
  pkgs,
  lib,
  ...
}: {
  # hardware.opengl.driSupport32Bit = true;
  imports = [
    ../../hardware/opengl.nix
  ];
  programs.steam = {
    enable = true;
    extraCompatPackages = [pkgs.proton-ge-bin];
  };
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
    ];
}
