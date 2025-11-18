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
  home-manager.sharedModules = [
    (_: {
      imports = [ inputs.stylix.homeModules.stylix ];
      stylix = {
        enable = true;
        autoEnable = true;
        overlays.enable = false;

        polarity = "dark";
        base16Scheme = "${pkgs.base16-schemes}/share/themes/${theme}.yaml";

        targets = {
          kitty.variant256Colors = true;
          qt.platform = "qtct"; # or gtk
          cava.rainbow.enable = true;
          emacs.enable = false;
          hyprlock.enable = false;
          starship.enable = false;
          tmux.enable = false;
          waybar.addCss = false;

          neovide.enable = false;
          neovim.enable = false;
          nixvim = {
            enable = false;
            plugin = "base16-nvim";
            transparentBackground = {
              main = true;
              numberLine = true;
              signColumn = true;
            };
          };

          zen-browser = {
            enable = true;
            profileNames = [ "default" ];
          };
          floorp = {
            enable = true;
            profileNames = [ "default" ];
          };
          librewolf = {
            enable = true;
            profileNames = [ "default" ];
          };
          firefox = {
            enable = true;
            profileNames = [ "default" ];
          };
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
        fonts = {
          monospace = {
            name = "JetBrainsMono Nerd Font";
            package = pkgs.nerd-fonts.jetbrains-mono;
          };
          sansSerif = {
            name = "Noto Sans";
            package = pkgs.noto-fonts;
          };
          serif = {
            name = "Noto Serif";
            package = pkgs.noto-fonts;
          };
          emoji = {
            name = "Noto Color Emoji";
            package = pkgs.noto-fonts-color-emoji;
          };
        };
      };
    })
  ];
}
