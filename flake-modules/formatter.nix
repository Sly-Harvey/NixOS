# Formatter module for flake-parts
# This module handles code formatting using treefmt-nix with nixfmt (RFC style)

{ inputs, ... }: {
  imports = [
    inputs.treefmt-nix.flakeModule
  ];

  perSystem = { config, pkgs, ... }: {
    # Treefmt configuration
    treefmt.config = {
      projectRootFile = "flake.nix";
      programs = {
        # Use nixfmt (RFC style) for Nix files
        nixfmt = {
          enable = true;
          package = pkgs.nixfmt-rfc-style;
        };
        # Format shell scripts
        shfmt.enable = true;
        # Format markdown files
        mdformat.enable = true;
        # Format YAML files
        yamlfmt.enable = true;
      };
      settings.global.excludes = [
        # Exclude lock files and generated files
        "*.lock"
        "result*"
        ".direnv"
        # Exclude specific directories that shouldn't be formatted
        "hardware-configuration.nix"
      ];
    };

    # Make treefmt available as the formatter
    formatter = config.treefmt.build.wrapper;
  };
}
