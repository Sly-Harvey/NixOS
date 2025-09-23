{
  inputs,
  outputs,
  pkgs,
  username,
  browser,
  terminal,
  locale,
  timezone,
  kbdLayout,
  kbdVariant,
  consoleKeymap,
  self,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.nix-index-database.nixosModules.nix-index
  ];

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "kvm"
      "input"
      "disk"
      "libvirtd"
      "video"
      "audio"
    ];
  };

  # Common home-manager options that are shared between all systems.
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.${username} =
      { pkgs, ... }:
      {
        # Let Home Manager install and manage itself.
        programs.home-manager.enable = true;

        xdg.enable = true;
        xdg.portal = {
          enable = true;
          extraPortals = with pkgs; [
            xdg-desktop-portal-hyprland
            xdg-desktop-portal-gtk
          ];
          xdgOpenUsePortal = true;
        };
        home = {
          inherit username;
          homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
          stateVersion = "23.11"; # Please read the comment before changing.
          sessionVariables = {
            EDITOR = "nvim";
            BROWSER = browser;
            TERMINAL = terminal;
          };
          # Packages that don't require configuration. If you're looking to configure a program see the /modules dir
          packages = with pkgs; [
            # Applications
            #kate

            # Terminal
            fzf
            fd
            git
            gh
            htop
            libjxl
            microfetch
            nix-prefetch-scripts
            ripgrep
            tldr
            unrar
            unzip
          ];
        };
      };
  };

  # Filesystems support
  boot.supportedFilesystems = [
    "ntfs"
    "exfat"
    "ext4"
    "fat32"
    "btrfs"
  ];
  services = {
    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;

    # Depends on system
    # scx = {
    #   enable = true;
    #   package = pkgs.scx.rustscheds;
    #   scheduler = "scx_lavd"; # https://github.com/sched-ext/scx/blob/main/scheds/rust/README.md
    # };

    xserver = {
      enable = true;
      exportConfiguration = true; # Make sure /etc/X11/xkb is populated so localectl works correctly
      xkb = {
        layout = kbdLayout;
        variant = kbdVariant;
      };
    };

    blueman.enable = true;

    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        enableHidpi = true;
        package = pkgs.kdePackages.sddm;
        theme = "sddm-astronaut-theme";
        settings.Theme.CursorTheme = "Bibata-Modern-Classic";
        extraPackages = with pkgs; [
          kdePackages.qtmultimedia
          kdePackages.qtsvg
          kdePackages.qtvirtualkeyboard
        ];
      };
    };

    gnome.gnome-keyring.enable = true;

    printing.enable = true;

    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber = {
        enable = true;
        configPackages = [
          (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/11-bluetooth-policy.conf" ''
            bluetooth.autoswitch-to-headset-profile = false
          '')
        ];
      };
    };

    libinput.enable = true;
  };

  # Bootloader.
  boot = {
    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.linuxPackages_latest; # _latest, _zen, _xanmod_latest, _hardened, _rt, _OTHER_CHANNEL, etc.
    kernelParams = [
      "preempt=full" # lower latency but less throughput
    ];
    loader = {
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
      timeout = null; # Display bootloader indefinitely until user selects OS
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        gfxmodeEfi = "2715x1527"; # for 4k: 3840x2160
        gfxmodeBios = "2715x1527"; # for 4k: 3840x2160
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

  # Timezone and locale
  time.timeZone = timezone;
  i18n.defaultLocale = locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = locale;
    LC_IDENTIFICATION = locale;
    LC_MEASUREMENT = locale;
    LC_MONETARY = locale;
    LC_NAME = locale;
    LC_NUMERIC = locale;
    LC_PAPER = locale;
    LC_TELEPHONE = locale;
    LC_TIME = locale;
  };
  console.keyMap = consoleKeymap; # Configure console keymap

  security = {
    polkit.enable = true;
    #sudo.wheelNeedsPassword = false;
  };
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };

  # Enable networking
  networking = {
    # hostName = hostname; # Define your hostname.
    networkmanager.enable = true;
    # wireless.enable = true; # Enables wireless support via wpa_supplicant.
    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };
  security.rtkit.enable = true;

  users.defaultUserShell = pkgs.zsh;

  fonts.fontDir.enable = true;
  fonts.packages = with pkgs.nerd-fonts; [
    jetbrains-mono
    fira-code
  ];

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      # allowUnfreePredicate = _: true;
    };
  };

  environment.sessionVariables = {
    # These are the defaults, and xdg.enable does set them, but due to load
    # order, they're not set before environment.variables are set, which could
    # cause race conditions.
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_BIN_HOME = "$HOME/.local/bin";

    templates = "${self}/dev-shells";
  };

  environment.systemPackages = with pkgs; [
    killall
    lm_sensors
    gnome-disk-utility
    jq
    bibata-cursors
    sddm-astronaut # Overlayed
    pkgs.kdePackages.qtsvg
    pkgs.kdePackages.qtmultimedia
    pkgs.kdePackages.qtvirtualkeyboard
    # libsForQt5.qt5.qtgraphicaleffects

    # devenv
    # devbox
    # shellify
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  programs = {
    nix-index-database.comma.enable = true;

    # Enable dconf for home-manager
    dconf.enable = true;

    # Default shell
    zsh.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    nh = {
      enable = true;
      # Automatic garbage collection
      clean = {
        enable = true;
        extraArgs = "--keep-since 7d --keep 3";
      };
      flake = "/home/${username}/NixOS";
    };
  };
  nix = {
    # Nix Package Manager Settings
    settings = {
      auto-optimise-store = true; # May make rebuilds longer but less size
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org/"
        "https://chaotic-nyx.cachix.org/"
        "https://cachix.cachix.org"
        "https://hyprland.cachix.org"
        # "https://nixpkgs-wayland.cachix.org"
        # "https://devenv.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        # "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        # "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      use-xdg-base-directories = false;
      warn-dirty = false;
      keep-outputs = true;
      keep-derivations = true;
    };
    optimise.automatic = true;
    package = pkgs.nixVersions.latest;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
