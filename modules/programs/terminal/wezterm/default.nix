{ pkgs, ... }:
{
  home-manager.sharedModules = [
    (_: {
      home.packages = [ pkgs.wezterm ];
      xdg.configFile."wezterm/wezterm.lua".source = ./wezterm.lua;
    })
  ];
}
