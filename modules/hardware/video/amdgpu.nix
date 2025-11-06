{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
  };
  environment.systemPackages = with pkgs; [ rocmPackages.amdsmi ];
  # TODO: Use this instead of hardware.graphics
  # Can't test since i have nvidia
   hardware.amdgpu = {
     opencl.enable = true;
   };

  #hardware.graphics = {
  #  enable = true;
  #  enable32Bit = true;
  #  extraPackages = with pkgs; [
  #    amdvlk
  #    libvdpau-va-gl
  #    vaapiVdpau
  #  ];
  #  extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
  #};
}
