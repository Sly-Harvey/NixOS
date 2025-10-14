{ lib, ... }:
let
  vars = import ./variables.nix;
in
{
  imports = [
    ./hardware-configuration.nix
    ./host-packages.nix

    # Core Modules (Don't change unless you know what you're doing)
    ../../modules/scripts
    ../../modules/core/boot.nix
    ../../modules/core/bash.nix
    ../../modules/core/zsh.nix
    ../../modules/core/starship.nix
    ../../modules/core/fonts.nix
    ../../modules/core/hardware.nix
    ../../modules/core/network.nix
    ../../modules/core/dns.nix
    ../../modules/core/nh.nix
    ../../modules/core/packages.nix
    ../../modules/core/printing.nix
    ../../modules/core/sddm.nix
    ../../modules/core/security.nix
    ../../modules/core/services.nix
    ../../modules/core/syncthing.nix
    ../../modules/core/system.nix
    ../../modules/core/users.nix
    # ../../modules/core/flatpak.nix
    # ../../modules/core/virtualisation.nix
    # ../../modules/core/dlna.nix

    # Optional
    ../../modules/hardware/drives # Automatically mount extra external/internal drives
    ../../modules/hardware/video/${vars.videoDriver}.nix # Enable gpu drivers defined in variables.nix
    ../../modules/desktop/${vars.desktop} # Set window manager defined in variables.nix
    ../../modules/programs/browser/${vars.browser} # Set browser defined in variables.nix
    ../../modules/programs/terminal/${vars.terminal} # Set terminal defined in variables.nix
    ../../modules/programs/editor/${vars.editor} # Set editor defined in variables.nix
    ../../modules/programs/cli/${vars.tuiFileManager} # Set file-manager defined in variables.nix
    ../../modules/programs/cli/tmux
    ../../modules/programs/cli/direnv
    ../../modules/programs/cli/lazygit
    ../../modules/programs/cli/cava
    ../../modules/programs/cli/btop
    ../../modules/programs/media/discord
    ../../modules/programs/media/spicetify
    # ../../modules/programs/media/youtube-music
    # ../../modules/programs/media/thunderbird
    # ../../modules/programs/media/obs-studio
    ../../modules/programs/media/mpv
    ../../modules/programs/misc/tlp
    ../../modules/programs/misc/thunar
    # ../../modules/programs/misc/lact # GPU fan, clock and power configuration
  ]
  ++ lib.optional (vars.games == true) ../../modules/core/games.nix;
  boot = {
    initrd.kernelModules = [
      "applespi"
      "intel_lpss_pci"
      "spi_pxa2xx_platform"
    ];
    kernelModules = [
      "applespi"
      "intel_lpss_pci"
      "spi_pxa2xx_platform"
    ];
  };
  # Fan control
  services.mbpfan = {
    enable = true;
    aggressive = false;
    settings = {
    };
  };
  home-manager.sharedModules = [
    {
      programs.waybar.settings.mainBar.modules-right = lib.mkForce [
        # "custom/gpuinfo"
        "cpu"
        "memory"
        "backlight"
        "pulseaudio"
        "network"
        "bluetooth"
        "tray"
        "battery"
      ];
      wayland.windowManager.hyprland.settings = {
        input = lib.mkForce {
          follow_mouse = 1;

          sensitivity = 0.8; # -1.0 - 1.0, 0 means no modification.
          accel_profile = "flat";
          force_no_accel = false;
        };
        monitor = [
          # Macbook pro screen
          "desc:Apple Computer Inc Color LCD,preferred,0x0,2"
        ];
      };
    }
  ];
  nix = {
    distributedBuilds = true;
    settings.builders-use-substitutes = true;
    buildMachines = [
      {
        protocol = "ssh";
        hostName = "NixOS";
        sshUser = "builder";
        sshKey = "/root/.ssh/id_ed25519";
        system = "x86_64-linux";
        maxJobs = 4;
        speedFactor = 5;
        supportedFeatures = [
          "kvm"
          "big-parallel"
        ];
        mandatoryFeatures = [ "big-parallel" ];
      }
    ];
  };
}
