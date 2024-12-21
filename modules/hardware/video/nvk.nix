# This module uses nouveau with NVK which is the nvidia open-source user-space driver and is not recommended to use as of 30/05/24 since it's unstable
{pkgs, ...}: let
  env = {
    NVK_I_WANT_A_BROKEN_VULKAN_DRIVER = "1"; # Adds support for my gpu (gtx 1080)
    # MESA_VK_VERSION_OVERRIDE = "1.3";
    # __GLX_VENDOR_LIBRARY_NAME = "mesa";
    # GALLIUM_DRIVER = "zink";
    # MESA_LOADER_DRIVER_OVERRIDE = "zink"; # TODO TEST
    # MESA_VK_DEVICE_SELECT="nvk";

    WLR_RENDERER = "vulkan";
    __GL_GSYNC_ALLOWED = "1"; # GSync
  };
in {
  boot = {
    kernelParams = [
      "nouveau.config=NvGspRm=1"
      "nouveau.config=NvModesetKms=0" # TODO Test
      "nouveau.debug=info,VBIOS=info,gsp=debug" # TODO Remove
      # "nouveau.modeset=1"
    ];
    kernelModules = ["nouveau"];
    blacklistedKernelModules = ["nvidia" "nvidia_uvm"];
  };

  environment.sessionVariables = env;
  environment.variables = env;

  services.xserver.videoDrivers = ["modesetting"]; # "modesetting" is better than "nouveau"
  # environment.variables.WLR_NO_HARDWARE_CURSORS = "1";

  hardware = {
    # nvidia.package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.latest;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        mesa # Enables mesa
        mesa.drivers # Enables the use of mesa drivers

        nvidia-vaapi-driver # Not sure if this is needed
        vaapiVdpau # Not sure if this is needed
        libvdpau-va-gl # Not sure if this is needed
      ];
    };
  };
}
