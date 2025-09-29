{
  pkgs,
  lib,
  host,
  ...
}:
let
  inherit (import ../../hosts/${host}/variables.nix) sddmTheme;
  sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "${sddmTheme}";
    themeConfig =
      if lib.hasSuffix "black_hole" sddmTheme then
        {
          ScreenPadding = "";
          FormPosition = "center"; # left, center, right
        }
      else if lib.hasSuffix "astronaut" sddmTheme then
        {
          PartialBlur = "false";
          FormPosition = "center"; # left, center, right
        }
      else if lib.hasSuffix "purple_leaves" sddmTheme then
        {
          PartialBlur = "false";
        }
      else
        { };
  };
in
{
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      enableHidpi = true;
      package = lib.mkForce pkgs.kdePackages.sddm;
      extraPackages = [
        sddm-astronaut
        pkgs.kdePackages.qtsvg # Sddm Dependency
        pkgs.kdePackages.qtmultimedia # Sddm Dependency
        pkgs.kdePackages.qtvirtualkeyboard # Sddm Dependency
      ];
      settings.Theme.CursorTheme = "Bibata-Modern-Classic";
      theme = "sddm-astronaut-theme";
    };
  };

  environment.systemPackages = [
    sddm-astronaut
    pkgs.kdePackages.qtsvg # Sddm Dependency
    pkgs.kdePackages.qtmultimedia # Sddm Dependency
    pkgs.kdePackages.qtvirtualkeyboard # Sddm Dependency
  ];
}
