# Hosts module for flake-parts
#
# This module defines NixOS system configurations using a simple, direct approach.
# It provides nixosConfigurations directly without complex flake-parts integration
# to avoid evaluation issues.
#
# Key features:
# - Direct nixosSystem definitions
# - Settings passed via specialArgs
# - Support for multiple hosts
#
# Usage: Add new hosts by extending the nixosConfigurations attribute set

{ inputs, config, ... }: {
  flake.nixosConfigurations.Default = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit inputs;
      outputs = config.flake;
      self = inputs.self;
      hostname = "Default";
    } // config.flake.settings;
    modules = [
      ../hosts/Default/configuration.nix
    ];
  };
}
