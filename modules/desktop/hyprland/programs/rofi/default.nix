{
  pkgs,
  lib,
  host,
  ...
}:
let
  inherit (import ../../../../../hosts/${host}/variables.nix) terminal;
in
{
  home-manager.sharedModules = [
    (_: {
      programs.rofi = {
        enable = true;
        settings = import ./config.nix {inherit terminal lib pkgs;};
        plugins = with pkgs; [
          rofi-emoji # https://github.com/Mange/rofi-emoji 🤯
          rofi-games # https://github.com/Rolv-Apneseth/rofi-games 🎮
        ];
      };
      xdg.configFile."rofi/launchers" = {
        source = ./launchers;
        recursive = true;
      };
      xdg.configFile."rofi/colors" = {
        source = ./colors;
        recursive = true;
      };
    })
  ];
}
