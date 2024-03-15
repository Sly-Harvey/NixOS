{
  home-manager,
  username,
  pkgs,
  ...
}: {
  home-manager.users.${username} = {config, ...}: {
    imports = [
      ./cava
      ./wallpapers
    ];

    qt = {
      enable = true;
      platformTheme = "gtk"; # gnome
      #platformTheme = "gnome";
      #style = {
      #  name = "adwaita-dark";
      #  package = pkgs.adwaita-qt;
      #};
    };

    gtk = {
      enable = true;
      iconTheme = {
        name = "Yaru-magenta-dark";
        package = pkgs.yaru-theme;
      };

      theme = {
        #name = "Tokyonight-Dark-B-LB";
        #package = pkgs.tokyo-night-gtk;
        name = "Catppuccin-Macchiato-Compact-Pink-Dark";
        package = pkgs.catppuccin-gtk.override {
          accents = ["pink"];
          size = "compact";
          #tweaks = [ "rimless" "black" ];
          variant = "macchiato";
        };
      };

      cursorTheme = {
        #package = pkgs.phinger-cursors;
        #name = "phinger-cursors-light";
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
        size = 24;
      };
    };
    xdg.configFile = {
      "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
      "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
      "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
    };
  };
}
