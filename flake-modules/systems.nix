# Systems module for flake-parts (DEPRECATED)
# This module has been replaced by hosts.nix for better modularity
# Keeping for backward compatibility - will be removed in future versions

{ inputs, config, ... }: {
  # This configuration is now handled by flake-modules/hosts.nix
  # Please use the new hosts.nix module instead
  
  # Uncomment the following if you need the old behavior:
  # flake.nixosConfigurations = {
  #   Default = inputs.nixpkgs.lib.nixosSystem {
  #     system = "x86_64-linux";
  #     specialArgs = {
  #       inherit inputs;
  #       outputs = config.flake;
  #       self = config.flake;
  #     } // config.settings;
  #     modules = [./hosts/Default/configuration.nix];
  #   };
  # };
}
