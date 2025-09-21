# Dev-shells module for flake-parts
# This module handles development shell templates

{ ... }: {
  flake.templates = import ../dev-shells;
}

