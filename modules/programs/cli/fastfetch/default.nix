{
  home-manager.sharedModules = [
    (_: {
      programs.fastfetch = {
        enable = true;
      };
      xdg.configFile = {
        "fastfetch/config.jsonc".source = ./config.jsonc;
        "fastfetch/icons" = {
          source = ./icons;
          recursive = true;
        };
      };
    })
  ];
}
