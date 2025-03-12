{pkgs, ...}: let
  # package = pkgs.lact;
  package = pkgs.callPackage ../../../../pkgs/lact.nix {}; # TODO: remove when updated in nixpkgs
in {
  systemd = {
    packages = [package];
    services.lactd.wantedBy = ["multi-user.target"];
  };
  environment.systemPackages = [package];
}
