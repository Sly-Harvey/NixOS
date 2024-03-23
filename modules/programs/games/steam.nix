{
  pkgs,
  lib,
  ...
}: {
  # hardware.opengl.driSupport32Bit = true;
  imports = [
    ../../hardware/opengl.nix
  ];
  programs.steam.enable = true;
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
    ];
}
