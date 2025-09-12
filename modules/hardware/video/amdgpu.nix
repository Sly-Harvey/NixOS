# This module is untested since i don't own an amd gpu!
{pkgs, ...}: {
  services.xserver = {
    enable = true;
    videoDrivers = ["amdgpu"];
  };
  environment.systemPackages = with pkgs; [
    rocmPackages.amdsmi
    rocmPackages.clr.icd
    rocmPackages.rocm-smi
    ffmpeg
    clinfo
  ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      hashcat
      python3
      amdvlk
      libvdpau-va-gl
      vaapiVdpau
      vulkan-loader
      vulkan-extension-layer
      vulkan-validation-layers
    ];
    extraPackages32 = with pkgs; [driversi686Linux.amdvlk];
  };
}
