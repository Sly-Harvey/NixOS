# This module is untested since i don't own an amd gpu!
{pkgs, ...}: {
  boot = {
    initrd.kernelModules = ["amdgpu"]; # radeon etc.
    # blacklistedKernelModules = ["fglrx"];
    # kernelParams = ["radeon.cik_support=0" "amdgpu.cik_support=1"]; # for Sea Islands (CIK i.e. GCN 2) cards
    # kernelParams = ["radeon.si_support=0" "amdgpu.si_support=1"]; # for Southern Islands (SI i.e. GCN 1) cards
  };
  services.xserver = {
    enable = true;
    videoDrivers = ["amdgpu"];
  };
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
      libvdpau-va-gl
      vaapiVdpau
      vdpauinfo
      rocm-opencl-icd
      rocm-opencl-runtime

      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
    ];
    extraPackages32 = with pkgs; [driversi686Linux.amdvlk];
  };
}
