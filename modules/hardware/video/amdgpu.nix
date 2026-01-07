{ pkgs, ... }:

{
  services.xserver = {
    # enable = true;  # Already enabled in display manager
    videoDrivers = [ "amdgpu" ];
  };
  environment.systemPackages = with pkgs; [ rocmPackages.amdsmi ];
  hardware.amdgpu = {
    opencl.enable = true;
  };
}
