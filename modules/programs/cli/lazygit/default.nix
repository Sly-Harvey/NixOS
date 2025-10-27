{ ... }:
{
  home-manager.sharedModules = [
    (_: {
      home.shellAliases = {
        lg = "lazygit";
      };
      programs.lazygit = {
        enable = true;
        # settings.git.overrideGpg = true;
      };
    })
  ];
}
