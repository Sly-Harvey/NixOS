{
  username,
  pkgs,
  ...
}: {
  home-manager.users.${username} = {config, ...}: {
    imports = [
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
        package = pkgs.gnome.adwaita-icon-theme;
        name = "Adwaita";
      };

      theme = {
        name = "Flat-Remix-GTK-Grey-Darkest";
        package = pkgs.flat-remix-gtk;

        #name = "Tokyonight-Dark-B-LB";
        #package = pkgs.tokyo-night-gtk;

        #name = "Catppuccin-Macchiato-Compact-Pink-Dark";
        #package = pkgs.catppuccin-gtk.override {
        #  accents = ["pink"];
        #  size = "compact";
        #  #tweaks = [ "rimless" "black" ];
        #  variant = "macchiato";
        #};
      };

      cursorTheme = {
        #package = pkgs.phinger-cursors;
        #name = "phinger-cursors-light";
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
        size = 16;
      };
    };
    xdg.configFile = {
      "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
      "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
      "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
    };
  };
}
