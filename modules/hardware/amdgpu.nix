# This module is untested since i don't own an amd gpu!
{
  pkgs,
  ...
}: {
  boot.kernelModules = ["amdgpu" "radeon"];
  boot.blacklistedKernelModules = ["fglrx"];
  boot.kernelParams = ["radeon.si_support=0 radeon.cik_support=0" "amdgpu.si_support=1 amdgpu.cik_support=1"];
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      # Add any additional packages needed for specific AMD features or utilities
    ];
  };
}
