{ pkgs, ... }:
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        dconf.settings = {
          "org/gnome/desktop/interface" = {
            gtk-theme = "Dracula";
            color-scheme = "prefer-dark";
          };
        };

        home.pointerCursor = {
          gtk.enable = true;
          x11.enable = true;
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Classic";
          size = 16; # 24
        };

        qt = {
          enable = true;
          platformTheme.name = "gtk"; # gnome
          #platformTheme = "gnome";
          #style = {
          #  name = "adwaita-dark";
          #  package = pkgs.adwaita-qt;
          #};
        };

        gtk = {
          enable = true;

          theme = {
            name = "Dracula";
            package = pkgs.dracula-theme;
          };

          iconTheme = {
            name = "Dracula";
            package = pkgs.dracula-theme;
          };

          gtk3.extraConfig = {
            "gtk-application-prefer-dark-theme" = "1";
          };

          gtk4.extraConfig = {
            "gtk-application-prefer-dark-theme" = "1";
          };

          #font = {
          #  name = "Sans";
          #  size = 11;
          #};
        };

        xdg.configFile = {
          "gtk-4.0/assets".source =
            "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
          "gtk-4.0/gtk.css".source =
            "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
          "gtk-4.0/gtk-dark.css".source =
            "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
        };
      }
    )
  ];
}
