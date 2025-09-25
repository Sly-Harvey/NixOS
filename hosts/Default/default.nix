{ ... }:
let
  inherit (import ./variables.nix)
    editor
    browser
    terminal
    terminalFileManager
    videoDriver
    windowManager
    ;
in
{
  imports = [
    ./hardware-configuration.nix
    ./host-packages.nix

    ../../modules/core
    ../../modules/core/gaming.nix # Gaming module

    ../../modules/scripts

    ../../modules/hardware/video/${videoDriver}.nix # Enable gpu drivers defined in hosts/Default/variables.nix
    ../../modules/hardware/drives

    ../../modules/desktop/${windowManager} # Set window manager defined in hosts/Default/variables.nix

    ../../modules/programs/browser/${browser} # Set browser defined in hosts/Default/variables.nix
    ../../modules/programs/terminal/${terminal} # Set terminal defined in hosts/Default/variables.nix
    ../../modules/programs/editor/${editor} # Set editor defined in hosts/Default/variables.nix
    ../../modules/programs/cli/${terminalFileManager} # Set file-manager defined in hosts/Default/variables.nix
    ../../modules/programs/cli/starship
    ../../modules/programs/cli/tmux
    ../../modules/programs/cli/direnv
    ../../modules/programs/cli/lazygit
    ../../modules/programs/cli/cava
    ../../modules/programs/cli/btop
    ../../modules/programs/shell/bash
    ../../modules/programs/shell/zsh
    ../../modules/programs/media/discord
    ../../modules/programs/media/spicetify
    # ../../modules/programs/media/youtube-music
    # ../../modules/programs/media/thunderbird
    # ../../modules/programs/media/obs-studio
    ../../modules/programs/media/mpv
    ../../modules/programs/misc/tlp
    ../../modules/programs/misc/thunar
    ../../modules/programs/misc/lact # GPU fan, clock and power configuration
    # ../../modules/programs/misc/nix-ld
    # ../../modules/programs/misc/virt-manager
  ];
}
