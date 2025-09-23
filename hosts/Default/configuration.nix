{
  pkgs,
  videoDriver,
  username,
  hostname,
  editor,
  terminal,
  terminalFileManager,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/hardware/video/${videoDriver}.nix # Enable gpu drivers defined in flake.nix
    ../../modules/hardware/drives

    ../common.nix
    ../../modules/scripts

    ../../modules/desktop/hyprland # Enable hyprland window manager

    ../../modules/programs/terminal/${terminal} # Set terminal defined in flake.nix
    ../../modules/programs/editor/${editor} # Set editor defined in flake.nix
    ../../modules/programs/cli/${terminalFileManager} # Set file-manager defined in flake.nix
    ../../modules/programs/cli/starship
    ../../modules/programs/cli/tmux
    ../../modules/programs/cli/direnv
    ../../modules/programs/cli/lazygit
    ../../modules/programs/cli/btop
    ../../modules/programs/shell/bash
    ../../modules/programs/shell/zsh

    ../../modules/programs/misc/thunar
    ../../modules/programs/misc/lact # GPU fan, clock and power configuration
  ];

  # Home-manager config
  home-manager.sharedModules = [
    (_: {
      home.packages = with pkgs; [
        firefox # Lightweight browser (binary cache available)
        obsidian
      ];
    })
  ];

  # Define system packages here
  environment.systemPackages = with pkgs; [
  ];

  networking.hostName = hostname; # Set hostname defined in flake.nix

  # Stream my media to my devices via the network
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "${username}";
    dataDir = "/home/${username}"; # default location for new folders
    configDir = "/home/${username}/.config/syncthing";
  };

}
