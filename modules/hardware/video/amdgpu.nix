# This module is untested since i don't own an amd gpu!
{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
  };
  environment.systemPackages = with pkgs; [ rocmPackages.amdsmi ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
      libvdpau-va-gl
      vaapiVdpau
      # vulkan-loader
      # vulkan-extension-layer
      # vulkan-validation-layers
    ];
    extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
  };
}
