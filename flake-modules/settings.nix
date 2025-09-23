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
# - Feature toggles for optional components (audio, development)
#
# Usage: Settings are automatically available to all other modules via config.settings

_: {
  flake.settings = {
    # User configuration
    username = "zer0"; # automatically set with install.sh and live-install.sh
    editor = "vscode"; # vscode
    browser = "firefox"; # firefox
    terminal = "ghostty"; # ghostty
    terminalFileManager = "yazi"; # yazi or lf

    # Theme configuration
    sddmTheme = "purple_leaves"; # astronaut, black_hole, purple_leaves, jake_the_dog, hyprland_kath
    wallpaper = "kurzgesagt"; # see modules/themes/wallpapers

    # Hardware configuration
    videoDriver = "nvidia"; # nvidia, amdgpu, intel

    # System configuration
    hostname = "NixOS"; # CHOOSE A HOSTNAME HERE
    locale = "en_GB.UTF-8"; # CHOOSE YOUR LOCALE
    timezone = "Europe/London"; # CHOOSE YOUR TIMEZONE
    kbdLayout = "gb"; # CHOOSE YOUR KEYBOARD LAYOUT
    kbdVariant = "extd"; # CHOOSE YOUR KEYBOARD VARIANT (Can leave empty)
    consoleKeymap = "uk"; # CHOOSE YOUR CONSOLE KEYMAP (Affects the tty?)

    # Feature toggles
    features = {
      # Audio stack (can be disabled to reduce compilation time)
      audio = {
        enable = true;
        pipewire = true;
        lowLatency = false;
      };

      # Development tools
      development = {
        enable = true;
        docker = false;
        virt-manager = false;
      };
    };
  };
}
