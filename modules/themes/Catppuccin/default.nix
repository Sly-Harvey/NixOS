{
  username,
  pkgs,
  ...
}: let
  catppuccin-gtk = pkgs.catppuccin-gtk.overrideAttrs {
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "gtk";
      rev = "v1.0.3";
      fetchSubmodules = true;
      hash = "sha256-q5/VcFsm3vNEw55zq/vcM11eo456SYE5TQA3g2VQjGc=";
    };

    postUnpack = "";
  };
in {
  home-manager.users.${username} = {config, ...}: {
    xdg.configFile."hypr/wallpaper.png" = {
      # source = ../wallpapers/blue_hue.png; # Favourite
      source = ../wallpapers/moon.png; # Favourite
      # source = ../wallpapers/Train.jpg; # Favourite
      # source = ../wallpapers/Kurzgesagt-2.png; # Favourite
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk";
    };

    gtk = {
      enable = true;
      theme = {
        name = "catppuccin-macchiato-mauve-compact";
        package = catppuccin-gtk.override {
          accents = ["mauve"];
          variant = "macchiato";
          size = "compact";
        };
      };
      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };
      gtk3.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };
      gtk4.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };
    };
    xdg.configFile = {
      "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
      "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
      "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
    };
  };
}
