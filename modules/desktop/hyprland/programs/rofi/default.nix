{
  pkgs,
  lib,
  terminal,
  ...
}:
{
  home-manager.sharedModules = [
    (_: {
      programs.rofi =
        let
          inherit (lib) getExe;
        in
        {
          enable = true;
          terminal = "${getExe pkgs.${terminal}}";
          plugins = with pkgs; [
            rofi-emoji # https://github.com/Mange/rofi-emoji 🤯
          ];
          extraConfig = import ./config.nix;
        };
      xdg.configFile = {
        "rofi/config-music.rasi".source = ./config-music.rasi;
        "rofi/config-wallpaper.rasi".source = ./config-wallpaper.rasi;
        "rofi/launchers" = {
          source = ./launchers;
          recursive = true;
        };
        "rofi/colors" = {
          source = ./colors;
          recursive = true;
        };
        "rofi/assets" = {
          source = ./assets;
          recursive = true;
        };
        "rofi/resolution" = {
          source = ./resolution;
          recursive = true;
        };
      };
    })
  ];
}
