# NixOS/hosts/Default/configuration.nix
{
  inputs,
  pkgs,
  videoDriver,
  hostname,
  browser,
  editor,
  terminal,
  terminalFileManager,
  shell,
  ...

}: {
  imports = [
    ./hardware-configuration.nix

    # Enable GPU drivers based on the flake input
    ../../modules/hardware/video/${videoDriver}.nix

    # Mount all drives in ../../modules/hardware/drives/*.nix
    ../../modules/hardware/drives

    # Shared system/user config (e.g., locale, fonts, nix settings)
    ../common.nix

    # Useful custom system/user scripts
    ../../modules/scripts

    # Enable one window manager (Hyprland here; comment out i3-gaps if needed)
    ../../modules/desktop/hyprland

    # General applications
    ../../modules/programs/games
    ../../modules/programs/browser/${browser}
    ../../modules/programs/terminal/${terminal}
    ../../modules/programs/editor/${editor}
    ../../modules/programs/cli/${terminalFileManager}
    ../../modules/programs/cli/starship
    ../../modules/programs/cli/tmux
    ../../modules/programs/cli/direnv
    ../../modules/programs/cli/lazygit
    ../../modules/programs/cli/cava
    ../../modules/programs/cli/btop
    ../../modules/programs/shell/bash
    ../../modules/programs/shell/fish
    ../../modules/programs/shell/${shell}
    ../../modules/programs/media/discord
    ../../modules/programs/media/spicetify
    # ../../modules/programs/media/youtube-music
    # ../../modules/programs/media/thunderbird
    ../../modules/programs/media/obs-studio
    ../../modules/programs/media/mpv
    ../../modules/programs/misc/tlp
    ../../modules/programs/misc/nautilus
    ../../modules/programs/misc/lact
    ../../modules/programs/misc/nix-ld
    ../../modules/programs/misc/virt-manager

    # --- Cybersecurity wordlists ---
    ../../modules/programs/cyber

    # --- AthenaOS cyber modules from the Athena flake ---
    ../../modules/athena

  ];

  # --- Airgeddon language fix
  nixpkgs.overlays = [ (import ../../overlays/airgeddon-overlay.nix) ];

  # Shared Home-Manager modules (used by all home users)
  home-manager.sharedModules = [
    (_: {
      home.packages = with pkgs; [
        github-desktop
        obsidian
        # krita
        # gimp
      ];
    })
  ];

  # Define system packages here (you can add system-wide CLI apps)
  environment.systemPackages = with pkgs; [];

  # Set the machine hostname from flake input
  networking.hostName = hostname;

  ########################################
  ## Force processes to use cores 16-31 ##
  ########################################

  # Apply CPU affinity system-wide (for systemd services)
  systemd.settings.Manager.CPUAffinity = "16-31";
}
