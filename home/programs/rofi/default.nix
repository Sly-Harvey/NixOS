{ config, pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    terminal = "${pkgs.cool-retro-term}/bin/cool-retro-term";
    theme = ./launcher/type-6/style-5.rasi;
  };
    #home.file.".config/rofi/theme.rasi".source = ./config.rasi;
    #home.file.".config/rofi/launcher" = {
    #	source = ./launcher;
    #    recursive = true;
    #};
}
