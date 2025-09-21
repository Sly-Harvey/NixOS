# Systems module for flake-parts
# This module handles nixosConfigurations

{ inputs, config, ... }: {
  flake.nixosConfigurations = {
    Default = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
        outputs = config.flake;
        self = config.flake;
      } // config.settings;
      modules = [./hosts/Default/configuration.nix];
    };
  };
}
