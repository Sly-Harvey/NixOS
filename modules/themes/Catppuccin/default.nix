{
  pkgs,
  wallpaper,
  ...
}: let
  variant = "mocha";
  accent = "mauve";
  catppuccin-kvantum-pkg = pkgs.catppuccin-kvantum.override {inherit variant accent;};
  catppuccin = "catppuccin-${variant}-${accent}";
in {
  home-manager.sharedModules = [
    ({config, ...}: {
      home.packages = [catppuccin-kvantum-pkg];

      qt = {
        enable = true;
        platformTheme.name = "gtk";
        style.name = "kvantum";
      };
      gtk = {
        enable = true;
        theme = {
          name = "${catppuccin}-compact";
          package = pkgs.catppuccin-gtk.override {
            variant = variant;
            accents = [accent];
            size = "compact";
          };
        };
        iconTheme = {
          # package = pkgs.adwaita-icon-theme;
          # name = "Adwaita";
          package = pkgs.papirus-icon-theme;
          name = "Papirus-Dark";
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

      # Set wallpaper
      services.hyprpaper = {
        enable = true;
        settings = {
          preload = ["${../wallpapers/${wallpaper}}"];
          wallpaper = [",${../wallpapers/${wallpaper}}"];
        };
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

      xdg.configFile = {
        "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
        "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
        "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
        "Kvantum/${catppuccin}".source = "${catppuccin-kvantum-pkg}/share/Kvantum/${catppuccin}";
        "Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini {}).generate "kvantum.kvconfig" {
          General.theme = catppuccin;
        };
      };
    })
  ];
}
