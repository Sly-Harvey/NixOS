{pkgs, ...}: {
  fonts.packages = with pkgs.nerd-fonts; [jetbrains-mono];
  home-manager.sharedModules = [
    (_: {
      programs.ghostty = {
        enable = true;
        settings = {
          # Font configuration
          font-family = "JetBrainsMono Nerd Font";
          font-size = 12;
          
          # Theme and colors (Catppuccin Mocha)
          background = "1e1e2e";
          foreground = "cdd6f4";
          cursor-color = "f5e0dc";
          selection-background = "585b70";
          selection-foreground = "cdd6f4";
          
          # Color palette (Catppuccin Mocha)
          palette = [
            # Normal colors
            "0=#45475a"   # black
            "1=#f38ba8"   # red
            "2=#a6e3a1"   # green
            "3=#f9e2af"   # yellow
            "4=#89b4fa"   # blue
            "5=#f5c2e7"   # magenta
            "6=#94e2d5"   # cyan
            "7=#bac2de"   # white
            
            # Bright colors
            "8=#585b70"   # bright black
            "9=#f38ba8"   # bright red
            "10=#a6e3a1"  # bright green
            "11=#f9e2af"  # bright yellow
            "12=#89b4fa"  # bright blue
            "13=#f5c2e7"  # bright magenta
            "14=#94e2d5"  # bright cyan
            "15=#a6adc8"  # bright white
          ];
          
          # Terminal behavior
          scrollback-limit = 10000;
          copy-on-select = true;
          confirm-close-surface = false;
          mouse-hide-while-typing = true;
          
          # Window settings
          window-decoration = true;
          window-theme = "dark";
          
          # Tab settings
          tab-width = 4;
          
          # Performance
          unfocused-split-opacity = 0.8;
        };
      };
    })
  ];
}
