{ inputs, pkgs, ... }:
{
  home-manager.sharedModules = [
    (_: {
      imports = [ inputs.nix-doom-emacs-unstraightened.homeModule ];
      services.emacs.enable = true;
      programs.doom-emacs = {
        enable = true;
        doomDir = inputs.doom-config;
      };
      home.packages = with pkgs; [nil nixfmt]; # Nix Stuff
    })
  ];
}
