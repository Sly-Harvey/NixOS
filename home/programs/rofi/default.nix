{pkgs, ...}: {
  programs.rofi = {
    enable = true;
    terminal = "${pkgs.cool-retro-term}/bin/cool-retro-term";
    # theme = ./launchers/type-2/style-2.rasi;
    #theme = ./launchers/type-2/style-12.rasi;
  };
  home.file.".config/rofi/config-music.rasi".source = ./config-music.rasi;
  home.file.".config/rofi/config-long.rasi".source = ./config-long.rasi;
  home.file.".config/rofi/config-wallpaper.rasi".source = ./config-wallpaper.rasi;
  home.file.".config/rofi/launchers" = {
    source = ./launchers;
    recursive = true;
  };
  home.file.".config/rofi/colors" = {
    source = ./colors;
    recursive = true;
  };
  home.file.".config/rofi/pywal-color" = {
    source = ./pywal-color;
    recursive = true;
  };

  home.file.".config/rofi/assets" = {
    source = ./assets;
    recursive = true;
  };
  home.file.".config/rofi/resolution" = {
    source = ./resolution;
    recursive = true;
  };
}
