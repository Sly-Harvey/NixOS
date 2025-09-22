# Dev-shells module for flake-parts
# This module provides development shell templates for various programming languages
# Templates can be used with: nix flake init -t .#<template-name>

{ ... }: {
  # Export development shell templates
  flake.templates = import ../dev-shells;
  
  # Note: Individual dev shells could also be exposed via perSystem.devShells
  # if you want to provide ready-to-use development environments rather than templates
}
