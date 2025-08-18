{ pkgs, ... }: {
  home-manager.sharedModules = [ (_: { home.packages = [ pkgs.vuls ]; }) ];
}
