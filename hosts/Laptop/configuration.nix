{
  pkgs,
  username,
  hostname,
  ...
}: {
  imports = [
    ../common.nix
    ../../modules/desktop/gnome # Enable gnome desktop environment
    # ../../modules/desktop/hyprland # Enable hyprland window manager
    ../../modules/programs/games
    ./hardware-configuration.nix
  ];

  fileSystems."/mnt/seagate" = {
    device = "/dev/disk/by-uuid/E212-7894";
    fsType = "auto";
    options = [
      "X-mount.mkdir"
      "uid=1000"
      "gid=100"
      "noatime"
      "rw"
      "user"
      "exec"
      "umask=000"
      "nofail"
      # "auto"
      "x-gvfs-show"
      # "x-systemd.automount"
      "x-systemd.mount-timeout=5"
    ];
  };

  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/01DA12C1CBDE9100";
    fsType = "ntfs";
    options = [
      "X-mount.mkdir"
      "uid=1000"
      "gid=100"
      "noatime"
      "rw"
      "user"
      "exec"
      "umask=000"
      "nofail"
      # "async"
      "x-gvfs-show"
      "x-systemd.mount-timeout=5"
    ];
  };

  # Home-manager config
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      #vim
      #krita
      #steam
    ];

    /*
       home.sessionVariables = {
      EDITOR = "emacs";
    };
    */
  };

  networking.hostName = hostname; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Applications
    gimp
    gparted
    krita
    lutris
    mangohud
  ];

  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      #memorySize = 8192; # Use 8GB memory.
      memorySize = 4096; # Use 4GB memory.
      #memorySize = 2048; # Use 2GB memory.
      cores = 1;
    };
  };
  virtualisation.vmVariantWithBootLoader = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      #memorySize = 8192; # Use 8GB memory.
      memorySize = 4096; # Use 4GB memory.
      #memorySize = 2048; # Use 2GB memory.
      cores = 1;
    };
  };

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
