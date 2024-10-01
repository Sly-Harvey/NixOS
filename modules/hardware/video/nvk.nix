# This module uses nouveau with NVK which is the nvidia open-source user-space driver and is not recommended to use as of 30/05/24 since it is very unstable
{
  pkgs,
  ...
}: {
  boot = {
    kernelParams = [
      "nouveau.config=NvGspRm=1"
      "nouveau.modeset=1"
    ];
    kernelModules = ["nouveau"];
    blacklistedKernelModules = ["nvidia" "nvidia_uvm" "nvidia_drm" "nvidia_modeset"];
  };

  services.xserver.videoDrivers = ["nouveau"];
  # environment.variables.WLR_NO_HARDWARE_CURSORS = "1";

  hardware = {
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
