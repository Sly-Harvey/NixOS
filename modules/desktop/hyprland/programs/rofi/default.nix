{
  pkgs,
  lib,
  terminal,
  ...
}: {
  home-manager.sharedModules = [
    (_: {
      programs.rofi = let
        inherit (lib) getExe;
      in {
        enable = true;
        package = pkgs.rofi-wayland;
        terminal = "${getExe pkgs.${terminal}}";
        plugins = with pkgs; [
          rofi-emoji-wayland # https://github.com/Mange/rofi-emoji 🤯
          rofi-games # https://github.com/Rolv-Apneseth/rofi-games 🎮
        ];
      };
      xdg.configFile."rofi/config-music.rasi".source = ./config-music.rasi;
      xdg.configFile."rofi/config-long.rasi".source = ./config-long.rasi;
      xdg.configFile."rofi/config-wallpaper.rasi".source = ./config-wallpaper.rasi;
      xdg.configFile."rofi/launchers" = {
        source = ./launchers;
        recursive = true;
      };
      xdg.configFile."rofi/colors" = {
        source = ./colors;
        recursive = true;
      };
      xdg.configFile."rofi/assets" = {
        source = ./assets;
        recursive = true;
      };
      xdg.configFile."rofi/resolution" = {
        source = ./resolution;
        recursive = true;
      };
    })
  ];
}
