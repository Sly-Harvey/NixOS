{
  description = "A simple flake for an atomic system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    
    # Flake-parts for modular configuration
    flake-parts.url = "github:hercules-ci/flake-parts";
    
    # Treefmt for unified formatting
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";
    betterfox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
    };
    thunderbird-catppuccin = {
      url = "github:catppuccin/thunderbird";
      flake = false;
    };

  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        # Core configuration modules
        ./flake-modules/settings.nix
        ./flake-modules/hosts.nix          # Replaces systems.nix with better modularity
        
        # Feature modules
        ./flake-modules/dev-shells.nix
        ./flake-modules/overlays.nix
        ./flake-modules/packages.nix
        ./flake-modules/formatter.nix
        
        # New modular components
        ./flake-modules/services.nix       # Common service configurations
        ./flake-modules/themes.nix         # Centralized theme management
        ./flake-modules/hardware.nix       # Hardware profiles and configurations
        
        # Deprecated (keeping for compatibility)
        # ./flake-modules/systems.nix      # Use hosts.nix instead
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
    };
}
