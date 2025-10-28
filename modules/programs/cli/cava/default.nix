{ ... }:
{
  home-manager.sharedModules = [
    (_: {
      programs.cava = {
        enable = true;
        settings = {
          general = {
            framerate = 60;
            sensitivity = 100; # Default
            autosens = 1;
          };
        };
      };
    })
  ];
}
