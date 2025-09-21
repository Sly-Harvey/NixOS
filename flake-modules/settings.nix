# Settings module for flake-parts
# This module provides the user and system configuration settings
# that were previously defined in the main flake.nix

{ ... }: {
  flake.settings = {
    # User configuration
    username = "zer0"; # automatically set with install.sh and live-install.sh
    editor = "nixvim"; # nixvim, vscode, helix, nvchad, neovim, emacs (WIP)
    browser = "zen"; # firefox, floorp, zen
    terminal = "kitty"; # kitty, alacritty, wezterm
    terminalFileManager = "yazi"; # yazi or lf
    sddmTheme = "purple_leaves"; # astronaut, black_hole, purple_leaves, jake_the_dog, hyprland_kath
    wallpaper = "kurzgesagt"; # see modules/themes/wallpapers

    # System configuration
    videoDriver = "nvidia"; # CHOOSE YOUR GPU DRIVERS (nvidia, amdgpu or intel)
    hostname = "NixOS"; # CHOOSE A HOSTNAME HERE
    locale = "en_GB.UTF-8"; # CHOOSE YOUR LOCALE
    timezone = "Europe/London"; # CHOOSE YOUR TIMEZONE
    kbdLayout = "gb"; # CHOOSE YOUR KEYBOARD LAYOUT
    kbdVariant = "extd"; # CHOOSE YOUR KEYBOARD VARIANT (Can leave empty)
    consoleKeymap = "uk"; # CHOOSE YOUR CONSOLE KEYMAP (Affects the tty?)
  };
}
