# This module is untested since i don't own an amd gpu!
{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
  };
  environment.systemPackages = with pkgs; [ rocmPackages.amdsmi ];
  # TODO: Use this instead of hardware.graphics
  # Can't test since i have nvidia
  # hardware.amdgpu = {
  #   opencl.enable = true;
  #   amdvlk = {
  #     enable = true;
  #     settings = {
  #       AllowVkPipelineCachingToDisk = 1; # enable pipeline caching
  #       EnableVmAlwaysValid = 1; # better memory management
  #       IFH = 0; # disable image view feedback
  #       # ShaderCacheMode = 1; # enable shader cache
  #       # ShaderCacheMaxSize = 512; # set cache size limit (MB)
  #     };
  #   };
  # };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
      libvdpau-va-gl
      vaapiVdpau
    ];
    extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
  };
}
