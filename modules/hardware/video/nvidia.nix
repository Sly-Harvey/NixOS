{
  lib,
  pkgs,
  config,
  ...
}: let
  nvidiaDriverChannel = config.boot.kernelPackages.nvidiaPackages.beta; # stable, latest, etc.
in {
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"]; # or "nvidiaLegacy470 etc.
  boot.kernelParams = lib.optionals (lib.elem "nvidia" config.services.xserver.videoDrivers) [
    "nvidia-drm.modeset=1"
    "nvidia_drm.fbdev=1"
  ];
  environment.variables = {
    #VK_DRIVER_FILES = /run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json;
    GBM_BACKEND = "nvidia-drm";
    WLR_NO_HARDWARE_CURSORS = "1";
    LIBVA_DRIVER_NAME = "nvidia"; # hardware acceleration
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
  nixpkgs.config = {
    nvidia.acceptLicense = true;
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "cudatoolkit"
      "nvidia-persistenced"
      "nvidia-settings"
      "nvidia-x11"
    ];
  };
  hardware = {
    nvidia = {
      open = false;
      nvidiaSettings = false;
      powerManagement.enable = false; # This can cause sleep/suspend to fail and saves entire VRAM to /tmp/
      modesetting.enable = true;
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

        # vulkan-loader
        # vulkan-extension-layer
        # vulkan-validation-layers
      ];
    };
  };
}
