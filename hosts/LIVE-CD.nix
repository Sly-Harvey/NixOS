{
  lib,
  pkgs,
  inputs,
  modulesPath,
  terminal,
  ...
}: {
  imports = [
    "${modulesPath}/installer/cd-dvd/channel.nix"
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares.nix"
    inputs.home-manager.nixosModules.home-manager
    ../modules/desktop/hyprland # Enable hyprland window manager

    ../modules/hardware/video/nvidia.nix # Enable nvidia drivers
    # ../modules/hardware/video/amdgpu.nix # Enable amdgpu drivers
    ../modules/hardware/drives # Will still boot if these these drives are not found

    ../modules/programs/terminal/${terminal}
    ../modules/programs/shell/bash
    ../modules/programs/shell/zsh
    ../modules/programs/browser/firefox
    ../modules/programs/editor/nixvim
    # ../modules/programs/editor/vscode
    ../modules/programs/cli/starship
    ../modules/programs/cli/tmux
    ../modules/programs/cli/direnv
    ../modules/programs/cli/lf
    ../modules/programs/cli/lazygit
    ../modules/programs/cli/cava
    ../modules/programs/cli/btop
    ../modules/programs/misc/mpv
    ../modules/programs/misc/spicetify
  ];

  # Filesystems support
  boot.supportedFilesystems = ["ntfs" "exfat" "ext4" "fat32" "btrfs" "vfat" "xfs"];
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_6_10; # _latest, _zen_latest, _xanmod_latest _hardened, _rt, etc.
  };

  # Home-manager config
  home-manager.users.nixos = {
    home.username = "nixos";
    home.homeDirectory = "/home/nixos";

    home.stateVersion = "23.11"; # Please read the comment before changing.

    home.packages = with pkgs; [
      xfce.thunar
      #vim
      eza
      fzf
      fd
      git
      gh
      github-desktop
      htop
      nix-prefetch-scripts
      neofetch
      ripgrep
      tldr
      unzip

      krita
    ];

    home.sessionVariables = {
      # EDITOR = "emacs";
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };

  services = {
    qemuGuest.enable = true;
    # openssh.settings.PermitRootLogin = lib.mkForce "yes";
  };

  environment.systemPackages = with pkgs; let
    sddm-themes = pkgs.callPackage ../modules/themes/sddm/themes.nix {};
    scripts = pkgs.callPackage ../modules/scripts {};
  in [
    # Calamares for graphical installation
    # libsForQt5.kpmcore
    # calamares-nixos
    # calamares-nixos-autostart
    # calamares-nixos-extensions
    # # Get list of locales
    # glibcLocales

    # System
    scripts.tmux-sessionizer
    scripts.collect-garbage
    scripts.driverinfo
    scripts.underwatt
    # sddm-themes.sugar-dark
    sddm-themes.astronaut
    # sddm-themes.tokyo-night
    bibata-cursors
    libsForQt5.qt5.qtgraphicaleffects # For sddm to function properly

    # Development
    devbox # faster nix-shells
    shellify # faster nix-shells
  ];

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = "x86_64-linux";
    overlays = [
      inputs.nur.overlay
    ];
  };

  # Enable wpa_supplicant, but don't start it by default.
  networking.wireless.enable = lib.mkDefault true;
  networking.wireless.userControlled.enable = true;
  systemd.services.wpa_supplicant.wantedBy = lib.mkOverride 50 [];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  security = {
    polkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

  # Enable dconf for home-manager
  programs.dconf.enable = true;

  # Enable sddm login manager
  services.xserver.enable = true;
  services.displayManager = {
    sddm = {
      enable = true;
      theme = "astronaut";
      settings.Theme.CursorTheme = "Bibata-Modern-Classic";
    };
    autoLogin = {
      enable = true;
      user = "nixos";
    };
  };

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

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

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
  services.getty.helpLine = ''
    The "nixos" and "root" accounts have empty passwords.

    To log in over ssh you must set a password for either "nixos" or "root"
    with `passwd` (prefix with `sudo` for "root"), or add your public key to
    /home/nixos/.ssh/authorized_keys or /root/.ssh/authorized_keys.

    If you need a wireless connection, type
    `sudo systemctl start wpa_supplicant` and configure a
    network using `wpa_cli`. See the NixOS manual for details.
  '';

  # Automatically log in at the virtual consoles.
  services.getty.autologinUser = "nixos";

  users.users = {
    root.initialHashedPassword = "";
    nixos = {
      initialHashedPassword = "";
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "video"
        "audio"
        "kvm"
        "input"
        "disk"
        "libvirtd"
      ];
    };
  };

  # Speed up install with these.
  system.extraDependencies = with pkgs; [
    stdenv
    stdenvNoCC # for runCommand
    busybox
    jq # for closureInfo
    # For boot.initrd.systemd
    makeInitrdNGTool
  ];

  nix = {
    settings = {
      trusted-users = [ "root" "nixos" ];
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://nix-gaming.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
    };
    package = pkgs.nixFlakes;
  };
}
