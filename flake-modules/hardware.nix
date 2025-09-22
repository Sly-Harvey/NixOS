# Hardware module for flake-parts
# This module provides hardware-specific configurations and profiles
# for different types of systems (desktop, laptop, server, etc.)

{ config, ... }: {
  flake.hardwareProfiles = {
    # Desktop profile - high performance, dedicated GPU
    desktop = {
      # GPU drivers
      videoDrivers = {
        nvidia = {
          modules = [ "./modules/hardware/video/nvidia.nix" ];
          packages = [ "nvidia-vaapi-driver" ];
        };
        amdgpu = {
          modules = [ "./modules/hardware/video/amdgpu.nix" ];
          packages = [ "amdvlk" ];
        };
        intel = {
          modules = [ "./modules/hardware/video/intel.nix" ];
          packages = [ "intel-media-driver" ];
        };
      };

      # Audio configuration
      audio = {
        enable = true;
        pipewire = true;
        lowLatency = false;
      };

      # Power management (minimal for desktop)
      power = {
        tlp.enable = false;
        powertop.enable = false;
      };
    };

    # Laptop profile - power efficiency, integrated graphics
    laptop = {
      # Typically integrated graphics
      videoDrivers = {
        intel = {
          modules = [ "./modules/hardware/video/intel.nix" ];
          packages = [ "intel-media-driver" "intel-gpu-tools" ];
        };
        amdgpu = {
          modules = [ "./modules/hardware/video/amdgpu.nix" ];
          packages = [ "amdvlk" "radeontop" ];
        };
      };

      # Audio configuration
      audio = {
        enable = true;
        pipewire = true;
        lowLatency = true;
      };

      # Power management (essential for laptop)
      power = {
        tlp.enable = true;
        powertop.enable = true;
        cpuFreqGovernor = "powersave";
      };

      # Laptop-specific features
      features = {
        touchpad = true;
        backlight = true;
        bluetooth = true;
        wifi = true;
      };
    };

    # Server profile - minimal graphics, maximum stability
    server = {
      # Minimal graphics
      videoDrivers = {
        intel = {
          modules = [ "./modules/hardware/video/intel.nix" ];
          packages = [ ];
        };
      };

      # No audio for servers
      audio = {
        enable = false;
        pipewire = false;
      };

      # Server power management
      power = {
        tlp.enable = false;
        powertop.enable = false;
        cpuFreqGovernor = "performance";
      };

      # Server-specific features
      features = {
        ssh = true;
        firewall = true;
        monitoring = true;
      };
    };
  };

  # Helper function to apply hardware profile
  flake.hardwareHelpers = {
    applyProfile = profileName: 
      config.flake.hardwareProfiles.${profileName} or config.flake.hardwareProfiles.desktop;
    
    # Get video driver modules for current profile
    getVideoDriverModules = videoDriver: profile:
      let
        profileConfig = config.flake.hardwareProfiles.${profile} or config.flake.hardwareProfiles.desktop;
        driverConfig = profileConfig.videoDrivers.${videoDriver} or profileConfig.videoDrivers.intel;
      in
        driverConfig.modules or [ ];
    
    # Get video driver packages for current profile  
    getVideoDriverPackages = videoDriver: profile:
      let
        profileConfig = config.flake.hardwareProfiles.${profile} or config.flake.hardwareProfiles.desktop;
        driverConfig = profileConfig.videoDrivers.${videoDriver} or profileConfig.videoDrivers.intel;
      in
        driverConfig.packages or [ ];
  };
}
