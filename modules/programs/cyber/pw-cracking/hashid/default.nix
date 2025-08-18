{ pkgs, ... }: {
  home-manager.sharedModules = [
    (_: {
      home.packages = [ pkgs.hashid ];
    })
  ];
}
