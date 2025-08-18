{ inputs, ... }: {
  home-manager.sharedModules = [
    ({ config, pkgs, ... }: {
      home.file."wordlists/sqlmap/".source =
        "${inputs.sqlmap}/data/txt/";
    })
  ];
}
