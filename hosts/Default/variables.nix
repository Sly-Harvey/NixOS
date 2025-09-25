{
  # User Configuration
  username = "zer0"; # Your username (auto-set with install.sh, live-install.sh, rebuild.sh)

  # Desktop Environment
  windowManager = "hyprland"; # Options: hyprland, i3
  terminal = "kitty"; # Options: kitty, alacritty, wezterm
  editor = "nixvim"; # Options: nixvim, vscode, helix, nvchad, neovim, emacs (WIP)
  browser = "zen"; # Options: firefox, floorp, zen
  terminalFileManager = "yazi"; # Options: yazi, lf

  # Theming
  sddmTheme = "astronaut"; # Options: astronaut, black_hole, purple_leaves, jake_the_dog, hyprland_kath
  wallpaper = "kurzgesagt"; # See modules/themes/wallpapers for options

  # Hardware Configuration
  videoDriver = "nvidia"; # CRITICAL: Choose your GPU driver (nvidia, amdgpu, intel)
  hostname = "NixOS"; # Your system hostname

  # Localization
  locale = "en_GB.UTF-8"; # System locale
  timezone = "Europe/London"; # Your timezone
  kbdLayout = "gb"; # Keyboard layout
  kbdVariant = "extd"; # Keyboard variant (can be empty)
  consoleKeymap = "uk"; # TTY keymap
}
