{
  pkgs,
  config,
  ...
}: {
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"]; # or "nvidiaLegacy470 etc.

  hardware = {
    nvidia = {
      open = false;
      nvidiaSettings = false;
      powerManagement.enable = true;
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    opengl = {
      extraPackages = with pkgs; [nvidia-vaapi-driver];
    };
  };
}
