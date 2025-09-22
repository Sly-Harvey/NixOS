# Settings module for flake-parts
# 
# This module serves as the central configuration hub for the entire NixOS system.
# It defines user preferences, system settings, hardware configuration, and feature toggles
# that are consumed by other modules and host configurations.
#
# Key features:
# - User configuration (username, preferred applications)
# - Theme and appearance settings (SDDM theme, wallpaper)
# - Hardware configuration (video driver selection)
# - System localization (locale, timezone, keyboard layout)
# - Feature toggles for optional components (audio, gaming, development)
#
# Usage: Settings are automatically available to all other modules via config.settings

{ lib, ... }: {
  options.settings = with lib; {
    # User configuration
    username = mkOption {
      type = types.str;
      default = "zer0";
      description = "Username for the system";
    };
    
    editor = mkOption {
      type = types.enum [ "vscode" "nvim" "emacs" ];
      default = "vscode";
      description = "Default text editor";
    };
    
    browser = mkOption {
      type = types.enum [ "firefox" "chromium" "brave" ];
      default = "firefox";
      description = "Default web browser";
    };
    
    terminal = mkOption {
      type = types.enum [ "ghostty" "alacritty" "kitty" "wezterm" ];
      default = "ghostty";
      description = "Default terminal emulator";
    };
    
    terminalFileManager = mkOption {
      type = types.enum [ "yazi" "lf" "ranger" ];
      default = "yazi";
      description = "Terminal file manager";
    };
    
    # Theme configuration
    sddmTheme = mkOption {
      type = types.enum [ "astronaut" "black_hole" "purple_leaves" "jake_the_dog" "hyprland_kath" ];
      default = "purple_leaves";
      description = "SDDM login theme";
    };
    
    wallpaper = mkOption {
      type = types.str;
      default = "kurzgesagt";
      description = "Wallpaper theme name";
    };

    # Hardware configuration
    videoDriver = mkOption {
      type = types.enum [ "nvidia" "amdgpu" "intel" ];
      default = "nvidia";
      description = "Video driver to use";
    };
    
    # System configuration
    hostname = mkOption {
      type = types.str;
      default = "NixOS";
      description = "System hostname";
    };
    
    locale = mkOption {
      type = types.str;
      default = "en_GB.UTF-8";
      description = "System locale";
    };
    
    timezone = mkOption {
      type = types.str;
      default = "Europe/London";
      description = "System timezone";
    };
    
    kbdLayout = mkOption {
      type = types.str;
      default = "gb";
      description = "Keyboard layout";
    };
    
    kbdVariant = mkOption {
      type = types.str;
      default = "extd";
      description = "Keyboard variant";
    };
    
    consoleKeymap = mkOption {
      type = types.str;
      default = "uk";
      description = "Console keymap";
    };
    
    # Feature toggles
    features = mkOption {
      type = types.submodule {
        options = {
          audio = mkOption {
            type = types.submodule {
              options = {
                enable = mkEnableOption "audio stack";
                pipewire = mkEnableOption "PipeWire audio server";
                lowLatency = mkEnableOption "low latency audio configuration";
              };
            };
            default = {
              enable = true;
              pipewire = true;
              lowLatency = false;
            };
            description = "Audio system configuration";
          };
          
          gaming = mkOption {
            type = types.submodule {
              options = {
                enable = mkEnableOption "gaming stack";
                steam = mkEnableOption "Steam gaming platform";
                lutris = mkEnableOption "Lutris game manager";
              };
            };
            default = {
              enable = false;
              steam = false;
              lutris = false;
            };
            description = "Gaming system configuration";
          };
          
          development = mkOption {
            type = types.submodule {
              options = {
                enable = mkEnableOption "development tools";
                docker = mkEnableOption "Docker containerization";
                virt-manager = mkEnableOption "Virtual machine management";
              };
            };
            default = {
              enable = true;
              docker = false;
              virt-manager = false;
            };
            description = "Development environment configuration";
          };
          

        };
      };
      description = "Feature toggle configuration";
    };
  };

  # Configuration values - these override the defaults defined in options above
  config = {
    # Make settings available to other flake-parts modules
    flake.settings = config.settings;
  };
}
