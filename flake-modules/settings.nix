# Settings module for flake-parts
# This module provides the user and system configuration settings
# that were previously defined in the main flake.nix
# Now enhanced with hardware profiles and theme integration

{ ... }: {
  flake.settings = {
    # User configuration
    username = "zer0"; # automatically set with install.sh and live-install.sh
    editor = "vscode"; # vscode, helix, emacs (WIP)
    browser = "firefox"; # firefox, floorp
    terminal = "ghostty"; # kitty, alacritty, wezterm, ghostty
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
      
      # Gaming stack (disabled by default to reduce compilation time)
      gaming = {
        enable = false;
        steam = false;
        lutris = false;
      };
      
      # Development tools
      development = {
        enable = true;
        docker = false;
        virt-manager = false;
      };
      
      # Media applications (disabled by default to reduce bloat)
      media = {
        discord = false;
        spotify = false;
        obs = false;
        mpv = false;
      };
    };
  };
}
