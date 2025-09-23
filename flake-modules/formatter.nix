# Formatter module for flake-parts
#
# This module provides unified code formatting using treefmt-nix.
# It configures multiple formatters for different file types to maintain
# consistent code style across the entire project.
#
# Supported formats:
# - Nix files: nixfmt-rfc-style (official RFC 166 formatter)
# - Shell scripts: shfmt
# - Markdown files: mdformat
# - YAML files: yamlfmt
#
# Usage: Run 'nix fmt' to format all supported files in the project

{ inputs, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
  ];

  perSystem =
    { config, pkgs, ... }:
    {
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
