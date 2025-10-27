{
  inputs,
  pkgs,
  host,
  ...
}:
let
  inherit (import ../../hosts/${host}/variables.nix) theme;
in
{
  imports = [ inputs.stylix.nixosModules.stylix ];
  stylix.enable = true;
  home-manager.sharedModules = [
    (_: {
      imports = [ inputs.stylix.homeModules.stylix ];
      stylix = {
        enable = true;
        autoEnable = true;

        # polarity = "dark";
        base16Scheme = "${pkgs.base16-schemes}/share/themes/${theme}.yaml";
        # base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

        targets = {
          grub.enable = false;
          neovim.enable = false;
          emacs.enable = false;
          hyprlock.enable = false;
          rofi.enable = false;
          starship.enable = false;
          kitty.variant256Colors = true;
          kitty.enable = true;
          qt.platform = "qtct"; # or gtk

          # nixvim.enable = false;
          # neovide.enable = false;
          # console.enable = false;
          # zen-browser = {
          #   enable = false;
          #   profileNames = [ "default" ];
          # };
          # floorp = {
          #   enable = false;
          #   profileNames = [ "default" ];
          # };
          # firefox = {
          #   enable = false;
          #   profileNames = [ "default" ];
          # };
          # chromium = {
          #   enable = false;
          #   profileNames = [ "default" ];
          # };
        };
        cursor = {
          name = "Bibata-Modern-Classic";
          package = pkgs.bibata-cursors;
          size = 24;
        };
        icons = {
          enable = true;
          package = pkgs.papirus-icon-theme;
          dark = "Papirus-Dark";
          light = "Papirus-Light";
        };
      };
    })
  ];
}
