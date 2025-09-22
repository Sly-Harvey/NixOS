# Hosts module for flake-parts
# This module provides a more flexible way to define multiple hosts
# with shared configuration and host-specific overrides

{ inputs, config, ... }: {
  flake.nixosConfigurations = let
    # Common arguments passed to all hosts
    commonArgs = {
      inherit inputs;
      outputs = config.flake;
      self = config.flake;
    } // config.settings;

    # Helper function to create a host configuration
    mkHost = { system, hostName, modules ? [], extraArgs ? {} }: 
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = commonArgs // extraArgs // { hostname = hostName; };
        modules = [
          ./hosts/${hostName}/configuration.nix
        ] ++ modules;
      };
  in {
    # Default host configuration
    Default = mkHost {
      system = "x86_64-linux";
      hostName = "Default";
    };

    # Example of how to add additional hosts:
    # Laptop = mkHost {
    #   system = "x86_64-linux";
    #   hostName = "Laptop";
    #   modules = [
    #     # Add laptop-specific modules here
    #   ];
    #   extraArgs = {
    #     # Override settings for laptop
    #     videoDriver = "intel";
    #   };
    # };
  };
}
