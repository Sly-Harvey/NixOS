{ pkgs, ... }: {
  home-manager.sharedModules = [
    (_: {
      home.packages = with pkgs; [ nuclei nuclei-templates ];
    })
  ];
}
