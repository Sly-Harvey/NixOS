# Packages module for flake-parts
# This module handles custom packages using perSystem

{ config, ... }: {
  perSystem = { pkgs, ... }: {
    packages = import ../pkgs { 
      inherit pkgs; 
      settings = config.settings; 
    };
  };
}

