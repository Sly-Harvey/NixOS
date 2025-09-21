# Formatter module for flake-parts
# This module handles code formatting

{ ... }: {
  perSystem = { pkgs, ... }: {
    formatter = pkgs.alejandra;
  };
}

