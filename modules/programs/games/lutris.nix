{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wineWowPackages.staging
    lutris
  ];
}
