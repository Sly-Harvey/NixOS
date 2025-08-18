{ pkgs, ... }: {
  home-manager.sharedModules = [
    (_: {
      home.packages = [ pkgs.dirb ];
      home.file."wordlists/dirb".source = "${pkgs.dirb}/share/dirb/wordlists";
    })
  ];
}
