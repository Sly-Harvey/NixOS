{ host, ... }:
let
  inherit (import ../hosts/${host}/variables.nix)
    videoDriver
    browser
    editor
    terminal
    terminalFileManager
    host
    windowManager
    ;
in
{
  imports = [
    ./hardware/video/${videoDriver}.nix # Enable gpu drivers defined in hosts/<HOST>/variables.nix
    ./hardware/drives

    ./core
    ./scripts

    ./desktop/${windowManager} # Set window manager defined in hosts/<HOST>/variables.nix

    ./programs/games
    ./programs/browser/${browser} # Set browser defined in hosts/<HOST>/variables.nix
    ./programs/terminal/${terminal} # Set terminal defined in hosts/<HOST>/variables.nix
    ./programs/editor/${editor} # Set editor defined in hosts/<HOST>/variables.nix
    ./programs/cli/${terminalFileManager} # Set file-manager defined in hosts/<HOST>/variables.nix
    ./programs/cli/starship
    ./programs/cli/tmux
    ./programs/cli/direnv
    ./programs/cli/lazygit
    ./programs/cli/cava
    ./programs/cli/btop
    ./programs/shell/bash
    ./programs/shell/zsh
    ./programs/media/discord
    ./programs/media/spicetify
    # ./programs/media/youtube-music
    # ./programs/media/thunderbird
    # ./programs/media/obs-studio
    ./programs/media/mpv
    ./programs/misc/tlp
    ./programs/misc/thunar
    ./programs/misc/lact # GPU fan, clock and power configuration
    # ./programs/misc/nix-ld
  ];
}
