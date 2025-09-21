# Overlays module for flake-parts
# This module handles overlays

{ inputs, config, ... }: {
  flake.overlays = import ../overlays { 
    inherit inputs; 
    settings = config.settings; 
  };
}

