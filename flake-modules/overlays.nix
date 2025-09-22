# Overlays module for flake-parts
#
# This module manages Nixpkgs overlays that modify or extend the package set.
# It imports overlay definitions and makes them available to the flake output.
#
# Key features:
# - Custom package additions (from ../pkgs)
# - Package modifications and overrides
# - Integration with settings for conditional overlays
# - NUR (Nix User Repository) integration
# - Stable package access via inputs.nixpkgs-stable
#
# Usage: Overlays are automatically applied to nixpkgs in host configurations

{ inputs, config, ... }: {
  flake.overlays = import ../overlays { 
    inherit inputs; 
    settings = config.settings; 
  };
}
