{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
  };
  environment.systemPackages = with pkgs; [ rocmPackages.amdsmi ];
  hardware.amdgpu = {
    opencl.enable = true;
  };
}
