{
  pkgs,
  username,
  ...
}: {
  home-manager.users.${username} = _: {
    home.packages = with pkgs; [
      rofi-wayland
    ];
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
  };
}
