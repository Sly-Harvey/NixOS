# Hosts module for flake-parts
#
# This module defines NixOS system configurations using a flexible, modular approach.
# It replaces the traditional direct nixosSystem definitions with a helper function
# that provides consistent argument passing and easier host management.
#
# Key features:
# - Centralized common arguments (inputs, outputs, settings)
# - Helper function (mkHost) for consistent host creation
# - Support for host-specific modules and argument overrides
# - Automatic hostname injection for host-specific configurations
#
# Usage: Add new hosts by calling mkHost with system, hostName, and optional modules/extraArgs

{ inputs, config, ... }: {
  flake.nixosConfigurations = let
    # Helper function to create a host configuration
    mkHost = { system, hostName, modules ? [], extraArgs ? {} }: 
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          outputs = config.flake;
          self = config.flake;
          hostname = hostName;
        } // config.flake.settings // extraArgs;
        modules = [
          ../hosts/${hostName}/configuration.nix
        ] ++ modules;
      };
  in {
    # Default host configuration
    Default = mkHost {
      system = "x86_64-linux";
      hostName = "Default";
    };

    # Example of how to add additional hosts:
    # Desktop2 = mkHost {
    #   system = "x86_64-linux";
    #   hostName = "Desktop2";
    #   modules = [
    #     # Add desktop-specific modules here
    #   ];
    #   extraArgs = {
    #     # Override settings for additional desktop
    #     videoDriver = "nvidia";
    #   };
    # };
  };
}
