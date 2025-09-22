# Themes module for flake-parts
# This module provides centralized theme management for the system
# including wallpapers, SDDM themes, and color schemes

{ config, ... }: {
  flake.themeConfig = {
    # Available wallpapers (from modules/themes/wallpapers)
    wallpapers = {
      kurzgesagt = "kurzgesagt";
      nature = "nature";
      abstract = "abstract";
      minimal = "minimal";
    };

    # Available SDDM themes
    sddmThemes = {
      astronaut = "astronaut";
      black_hole = "black_hole";
      purple_leaves = "purple_leaves";
      jake_the_dog = "jake_the_dog";
      hyprland_kath = "hyprland_kath";
    };

    # Color schemes for consistent theming
    colorSchemes = {
      catppuccin-mocha = {
        primary = "#cba6f7";
        secondary = "#89b4fa";
        accent = "#f38ba8";
        background = "#1e1e2e";
        surface = "#313244";
        text = "#cdd6f4";
      };
      
      nord = {
        primary = "#88c0d0";
        secondary = "#81a1c1";
        accent = "#bf616a";
        background = "#2e3440";
        surface = "#3b4252";
        text = "#eceff4";
      };

      gruvbox = {
        primary = "#83a598";
        secondary = "#fabd2f";
        accent = "#fb4934";
        background = "#282828";
        surface = "#3c3836";
        text = "#ebdbb2";
      };
    };

    # Current theme selection (from settings.nix)
    current = {
      wallpaper = config.settings.wallpaper or "kurzgesagt";
      sddmTheme = config.settings.sddmTheme or "purple_leaves";
      colorScheme = "catppuccin-mocha"; # Default color scheme
    };
  };

  # Helper functions for theme management
  flake.themeHelpers = {
    # Get wallpaper path
    getWallpaperPath = wallpaper: 
      "./modules/themes/wallpapers/${wallpaper}";
    
    # Get SDDM theme package name
    getSddmThemePackage = theme:
      "sddm-${theme}-theme";
    
    # Apply color scheme to configuration
    applyColorScheme = scheme: config:
      config // {
        colors = config.flake.themeConfig.colorSchemes.${scheme};
      };
  };
}
