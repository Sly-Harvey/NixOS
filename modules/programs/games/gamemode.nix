{pkgs, ...}: {
  environment.systemPackages = [pkgs.gamemode];
  programs.gamemode.enable = true;
}
