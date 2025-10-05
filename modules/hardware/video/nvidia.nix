{
  lib,
  pkgs,
  config,
  ...
}:
let
  nvidiaDriverChannel = config.boot.kernelPackages.nvidiaPackages.stable; # stable, latest, beta, etc.
in
{
  environment.sessionVariables = lib.optionalAttrs config.programs.hyprland.enable {
    GBM_BACKEND = "nvidia-drm";
    WLR_NO_HARDWARE_CURSORS = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # MOZ_DISABLE_RDD_SANDBOX = 1; # Potential security risk

    __GL_GSYNC_ALLOWED = "1"; # GSync
    __GL_VRR_ALLOWED = "1"; # VRR
    __GL_MaxFramesAllowed = "1"; # Reduces input lag
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ]; # or "nvidiaLegacy470", etc.
  boot.kernelParams = lib.optionals (lib.elem "nvidia" config.services.xserver.videoDrivers) [
    "nvidia-drm.modeset=1"
    "nvidia_drm.fbdev=1"

    # "nvidia.NVreg_RegistryDwords=RmEnableAggressiveVblank=1" # Experimental: reduce latency
  ];
  hardware = {
    nvidia = {
      open = false;
      # nvidiaPersistenced = true;
      nvidiaSettings = false;
      powerManagement.enable = true; # Fixes sleep/suspend

      modesetting.enable = true; # Modesetting is required.

      package = nvidiaDriverChannel;
    };
    graphics = {
      enable = true;
      # package = nvidiaDriverChannel;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };
  nixpkgs.config = {
    nvidia.acceptLicense = true;
    cudaSupport = true;
    allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "cudatoolkit"
        "nvidia-persistenced"
        "nvidia-settings"
        "nvidia-x11"
      ];
  };
  nix.settings = {
    substituters = [ "https://cuda-maintainers.cachix.org" ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };
}
