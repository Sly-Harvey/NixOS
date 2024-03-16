{
  pkgs,
  config,
  ...
}: {
  hardware = {
    nvidia = {
      open = false;
      nvidiaSettings = true;
      powerManagement.enable = true;
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    opengl = {
      extraPackages = with pkgs; [nvidia-vaapi-driver];
    };
  };
}
