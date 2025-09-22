# Services module for flake-parts
# This module provides common service configurations that can be shared
# across different hosts and easily toggled on/off

{ config, ... }: {
  # Define service configurations that can be imported by hosts
  flake.serviceModules = {
    # Syncthing file synchronization service
    syncthing = { username, ... }: {
      services.syncthing = {
        enable = true;
        openDefaultPorts = true;
        user = username;
        dataDir = "/home/${username}";
        configDir = "/home/${username}/.config/syncthing";
      };
    };

    # DLNA media server (commented out by default)
    dlna = { username, ... }: {
      services.minidlna = {
        enable = false; # Disabled by default
        openFirewall = true;
        settings = {
          friendly_name = "NixOS-DLNA";
          media_dir = [
            "/mnt/work/Pimsleur"
            "/mnt/work/Media/Films"
            "/mnt/work/Media/Series"
            "/mnt/work/Media/Videos"
            "/mnt/work/Media/Music"
          ];
          inotify = "yes";
          log_level = "error";
        };
      };
      users.users.minidlna.extraGroups = ["users"];
    };

    # SSH server configuration
    ssh = {
      services.openssh = {
        enable = false; # Disabled by default for security
        settings = {
          PasswordAuthentication = true;
          AllowUsers = null; # Allows all users by default
          UseDns = true;
          X11Forwarding = false;
          PermitRootLogin = "prohibit-password";
        };
      };
    };

    # Development services
    development = {
      # Enable Docker for development
      virtualisation.docker = {
        enable = false; # Disabled by default
        enableOnBoot = false;
      };
      
      # Enable libvirt for VMs
      virtualisation.libvirtd = {
        enable = false; # Disabled by default
        qemu.ovmf.enable = true;
      };
    };
  };
}
