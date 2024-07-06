{
  inputs,
  username,
  pkgs,
  ...
}: {
  imports = [inputs.catppuccin.nixosModules.catppuccin];
  home-manager.users.${username} = {config, ...}: {
    imports = [inputs.catppuccin.homeManagerModules.catppuccin];
    home.file.".config/hypr/wallpaper.png" = {
      # source = ../wallpapers/escape_velocity.jpg;
      # source = ../wallpapers/aurora_borealis.png;
      # source = ../wallpapers/blue_hue.png; # Favourite
      source = ../wallpapers/moon.png; # Favourite
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
      /* style = {
        package = pkgs.adwaita-qt;
        name = "adwaita-dark";
      }; */
    };

    catppuccin.flavor = "macchiato";
    gtk = {
      enable = true;
      catppuccin = {
        enable = true;
        accent = "mauve";
        size = "compact";
        # tweaks = [ "rimless" "black" ];
        flavor = "macchiato";
      };

      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
        #name = "Yaru-magenta-dark";
        #package = pkgs.yaru-theme;
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

      #font = {
      #  name = "Sans";
      #  size = 11;
      #};
    };

    xdg.configFile = {
      "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
      "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
      "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
    };
  };
}
