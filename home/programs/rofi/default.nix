{ config, pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    terminal = "${pkgs.cool-retro-term}/bin/cool-retro-term";
    theme = ./launcher/type-3/style-2.rasi;
    #theme = ./launcher/type-2/style-12.rasi;
  };
    #home.file.".config/rofi/theme.rasi".source = ./config.rasi;
    #home.file.".config/rofi/launcher" = {
    #	source = ./launcher;
    #    recursive = true;
    #};
}
