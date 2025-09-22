# Services module for flake-parts
# This module provides service configuration options that can be used in settings.nix

{ ... }: {
  # This module defines service options that are consumed by settings.nix
  # The actual service configurations are applied in host configurations
  # based on the feature toggles in settings.nix
}
