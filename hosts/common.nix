{
  pkgs,
  home-manager,
  username,
  ...
}: {
  imports = [
    home-manager.nixosModules.home-manager
  ];

  home-manager.users.${username} = _: {
    imports = [
      ../modules/nixvim
      ../modules/alacritty
      ../modules/direnv
      ../modules/lf
      ../modules/firefox
      ../modules/vscode
      ../modules/mpv
      ../modules/zsh
      ../modules/style
    ];

    home.username = username;
    home.homeDirectory = "/home/${username}";

    # The home.packages option allows you to install Nix packages into your
    # environment.
    home.packages = with pkgs; [
      (pkgs.writeShellScriptBin "hello" ''
        echo "Hello World!"
      '')
    ];

    home.sessionVariables = {
      # EDITOR = "emacs";
    };

    home.file.".local/bin/" = {
      source = ../scripts;
      recursive = true;
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };

  # Filesystems support
  boot.supportedFilesystems = ["ntfs" "exfat" "ext4" "fat32" "btrfs"];
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Bootloader.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.timeout = null; # Display bootloader indefinitely until user selects OS
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.gfxmodeEfi = "1920x1080";
  boot.loader.grub.theme = pkgs.stdenv.mkDerivation {
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

  security = {
    polkit.enable = true;
    #sudo.wheelNeedsPassword = false;
  };

  xdg.portal.enable = true;
  xdg.portal.configPackages = [pkgs.xdg-desktop-portal-gtk];

  # Enable dconf for home-manager
  programs.dconf.enable = true;

  # Enable sddm login manager
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.theme = "astronaut";
  services.xserver.displayManager.sddm.settings.Theme.CursorTheme = "Bibata-Modern-Classic";

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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Default shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  qt.style = "adwaita-dark";

  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "JetBrainsMono"
        "FiraCode"
      ];
    })
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; let
    sddm-themes = pkgs.callPackage ../../../home/themes/sddm/themes.nix {};
  in [
    # System
    adwaita-qt
    bibata-cursors
    libsForQt5.qt5.qtgraphicaleffects # For sddm to function properly
    nix-prefetch-scripts
    polkit
    libsForQt5.polkit-kde-agent
    sddm-themes.sugar-dark
    sddm-themes.astronaut
    sddm-themes.tokyo-night

    # Terminal
    btop
    cava
    eza
    fzf
    fd
    git
    gh
    htop
    jq
    lf
    neofetch
    ripgrep
    tldr
    unzip

    # Applications
    #gimp
    #krita
    #lutris
    #mpv
    #mangohud
    #spotify
    #steam
    #xfce.thunar

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
      #auto-optimise-store = true; # Disbabled for now because it takes a long time to build
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
      experimental-features = ["nix-command" "flakes"];
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
