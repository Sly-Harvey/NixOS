{
  pkgs,
  lib,
  config,
  terminal,
  ...
}: let
  # Define your custom args once
  scriptArgs = {
    inherit
      pkgs
      lib
      config
      terminal
      ;
  };

  scripts = [
    (import ./launcher.nix scriptArgs)
    (import ./tmux-sessionizer.nix scriptArgs)
    (import ./extract.nix scriptArgs)
    (import ./driverinfo.nix scriptArgs)
    # (import ./underwatt.nix scriptArgs) # NVIDIA-specific script - disabled
    # Add new scripts here as you create them
  ];
in {
  environment.systemPackages = scripts;
}
