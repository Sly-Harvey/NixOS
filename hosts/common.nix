{
  inputs,
  pkgs,
  username,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../modules/hardware/opengl.nix
    ../modules/programs/alacritty
    ../modules/programs/bash
    ../modules/programs/btop
    ../modules/programs/cava
    ../modules/programs/direnv
    ../modules/programs/firefox
    # ../modules/programs/firefox/firefox-system.nix
    ../modules/programs/kitty
    ../modules/programs/lazygit
    ../modules/programs/lf
    ../modules/programs/mpv
    ../modules/programs/nixvim
    ../modules/programs/starship
    ../modules/services/tlp # Set cpu power settings
    ../modules/programs/tmux
    ../modules/programs/vscodium
    ../modules/programs/spicetify
    ../modules/programs/zsh
  ];

  # Common home-manager options that are shared between all systems.
  home-manager.users.${username} = {pkgs, ...}: {
    # Packages that don't require configuration. If you're looking to configure a program see the /modules dir
    home.packages = with pkgs; [
      # Applications
      #kate
      xfce.thunar

      # Terminal
      eza
      fzf
      fd
      git
      gh
      htop
      jq
      lf
      #lolcat
      nix-prefetch-scripts
      neofetch
      ripgrep
      tldr
      unzip
    ];
  };

  # Filesystems support
  boot.supportedFilesystems = ["ntfs" "exfat" "ext4" "fat32" "btrfs"];
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Bootloader.
  boot = {
    tmp.cleanOnBoot = true;
    loader = {
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
      timeout = null; # Display bootloader indefinitely until user selects OS
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        gfxmodeEfi = "1920x1080";
        theme = pkgs.stdenv.mkDerivation {
          pname = "distro-grub-themes";
          version = "3.1";
          src = pkgs.fetchFromGitHub {
            owner = "AdisonCavani";
            repo = "distro-grub-themes";
            rev = "v3.1";
            hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
          };
          installPhase = "cp -r customize/nixos $out";
        };
      };
    };
  };

  security = {
    polkit.enable = true;
    #sudo.wheelNeedsPassword = false;
  };

  xdg.portal.enable = true;
  xdg.portal.configPackages = [pkgs.xdg-desktop-portal-gtk];

  # Enable dconf for home-manager
  programs.dconf.enable = true;

  # Enable sddm login manager
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.theme = "astronaut";
  services.displayManager.sddm.settings.Theme.CursorTheme = "Bibata-Modern-Classic";

  # Setup auth agent and keyring
  services.gnome.gnome-keyring.enable = true;
  systemd = {
    user.services.polkit-kde-authentication-agent-1 = {
      description = "polkit-kde-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Default user when using: sudo nixos-rebuild build-vm
  users.users.nixosvmtest.isNormalUser = true;
  users.users.nixosvmtest.initialPassword = "vm";
  users.users.nixosvmtest.group = "nixosvmtest";
  users.groups.nixosvmtest = {};

  # Default shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "JetBrainsMono"
        "FiraCode"
      ];
    })
  ];

  nixpkgs = {
    config.allowUnfree = true;
    # config.allowUnfreePredicate = _: true;
    overlays = [
      inputs.nur.overlay
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; let
    sddm-themes = pkgs.callPackage ../modules/themes/sddm/themes.nix {};
    scripts = pkgs.callPackage ../modules/scripts {};
  in [
    # System
    scripts.tmux-sessionizer
    scripts.collect-garbage
    sddm-themes.sugar-dark
    sddm-themes.astronaut
    sddm-themes.tokyo-night
    adwaita-qt
    bibata-cursors
    libsForQt5.qt5.qtgraphicaleffects # For sddm to function properly
    polkit
    libsForQt5.polkit-kde-agent

    # Development
    devbox # faster nix-shells
    shellify # faster nix-shells
    github-desktop
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  nix = {
    # Nix Package Manager Settings
    settings = {
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
        "https://nix-gaming.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
      experimental-features = ["nix-command" "flakes" "repl-flake"];
      use-xdg-base-directories = true;
      warn-dirty = false;
      keep-outputs = true;
      keep-derivations = true;
    };
    gc = {
      # Garbage Collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 3d";
    };
    optimise.automatic = true;
    package = pkgs.nixFlakes;
  };
}
