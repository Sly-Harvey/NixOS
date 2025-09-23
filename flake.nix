{
  description = "A simple flake for an atomic system";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org/"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0ZkA1xzdr+/N0pjrF3nM9iP+0D8w7c="
      "nix-community.cachix.org-1:mBs+gI2b9FJe3uG1Sze4jG68ii993C5wCq/NecjB8X8="
    ];
  };

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

  outputs =
    inputs@{ flake-parts, ... }:
    let
      flake = flake-parts.lib.mkFlake { inherit inputs; } {
        # Enable debug mode for better development experience
        debug = true;

        imports = [
          # Core configuration modules
          ./flake-modules/settings.nix # Central configuration hub
          ./flake-modules/hosts.nix # Host definitions and NixOS configurations

          # Feature modules
          ./flake-modules/dev-shells.nix # Development shell templates
          ./flake-modules/overlays.nix # Package overlays and modifications
          ./flake-modules/packages.nix # Custom packages
          ./flake-modules/formatter.nix # Code formatting with treefmt-nix
        ];

        systems = [
          "x86_64-linux"
        ];
      };
      sanitized = builtins.removeAttrs flake [
        "debug"
        "allSystems"
        "settings"
      ];
    in
    sanitized
    // {
      lib = (flake.lib or { }) // {
        settings = flake.settings or { };
      };
    };
}
