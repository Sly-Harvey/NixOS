{
  inputs,
  pkgs,
  videoDriver,
  username,
  hostname,
  editor,
  terminal,
  terminalFileManager,
  ...
}:
let
  inherit (builtins) concatStringsSep;
  fromRoot = segments: inputs.self + ("/" + concatStringsSep "/" segments);
in
{
  imports = [
    ./hardware-configuration.nix
    (fromRoot [
      "modules"
      "hardware"
      "video"
      (videoDriver + ".nix")
    ]) # Enable gpu drivers defined in flake.nix
    (fromRoot [
      "modules"
      "hardware"
      "drives"
    ])

    ../common.nix
    (fromRoot [
      "modules"
      "scripts"
    ])

    (fromRoot [
      "modules"
      "desktop"
      "hyprland"
    ]) # Enable hyprland window manager

    (fromRoot [
      "modules"
      "programs"
      "terminal"
      terminal
    ]) # Set terminal defined in flake.nix
    (fromRoot [
      "modules"
      "programs"
      "editor"
      editor
    ]) # Set editor defined in flake.nix
    (fromRoot [
      "modules"
      "programs"
      "cli"
      terminalFileManager
    ]) # Set file-manager defined in flake.nix
    (fromRoot [
      "modules"
      "programs"
      "cli"
      "starship"
    ])
    (fromRoot [
      "modules"
      "programs"
      "cli"
      "tmux"
    ])
    (fromRoot [
      "modules"
      "programs"
      "cli"
      "direnv"
    ])
    (fromRoot [
      "modules"
      "programs"
      "cli"
      "lazygit"
    ])
    (fromRoot [
      "modules"
      "programs"
      "cli"
      "btop"
    ])
    (fromRoot [
      "modules"
      "programs"
      "shell"
      "bash"
    ])
    (fromRoot [
      "modules"
      "programs"
      "shell"
      "zsh"
    ])

    (fromRoot [
      "modules"
      "programs"
      "misc"
      "thunar"
    ])
    (fromRoot [
      "modules"
      "programs"
      "misc"
      "lact"
    ]) # GPU fan, clock and power configuration
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
