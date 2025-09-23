# Packages module for flake-parts
#
# This module exposes custom packages using the perSystem pattern.
# It makes custom packages available per-system and integrates them with settings.
#
# Key features:
# - Per-system package building using perSystem
# - Integration with settings for conditional packages
# - Custom package definitions from ../pkgs
# - Automatic system-specific package availability
#
# Usage: Packages are available as flake outputs (e.g., nix build .#pokego)

{ config, ... }: {
  perSystem = { pkgs, ... }: {
    packages = import ../pkgs { 
      inherit pkgs; 
      settings = config.flake.settings; 
    };
  };
}
