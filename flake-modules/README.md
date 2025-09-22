# Flake Modules

This directory contains modular flake-parts configuration files that organize the flake functionality into focused, reusable components.

## Module Structure

### Core Modules

- **`settings.nix`** - Central configuration hub containing user preferences, system settings, hardware configuration, and feature toggles
- **`hosts.nix`** - Host definitions and NixOS system configurations with flexible host management using mkHost helper

### Feature Modules

- **`dev-shells.nix`** - Development shell templates for various programming languages
- **`formatter.nix`** - Unified code formatting using treefmt-nix (nixfmt-rfc-style, shfmt, mdformat, yamlfmt)
- **`overlays.nix`** - Package overlays and modifications for extending nixpkgs (custom packages, NUR, stable access)
- **`packages.nix`** - Custom package definitions using perSystem pattern for per-system availability

## Usage

The main configuration is controlled through `settings.nix`, which provides:

- User preferences (editor, browser, terminal)
- Theme settings (wallpaper, SDDM theme)
- Hardware settings (video driver)
- Feature toggles (audio, gaming, development)

## Design Principles

1. **Separation of Concerns** - Each module handles a specific aspect of the system configuration
2. **Settings Integration** - All modules access centralized settings via `config.settings`
3. **Flake-parts Best Practices** - Consistent use of flake-parts conventions and perSystem where appropriate
4. **Clean Architecture** - No empty placeholder modules or deprecated code
5. **Comprehensive Documentation** - Each module includes detailed header documentation explaining purpose and usage

## Module Integration

```nix
# Example of how modules work together:
settings.nix     -> Defines configuration options and feature toggles
hosts.nix        -> Consumes settings to create NixOS configurations  
overlays.nix     -> Uses settings for conditional package modifications
packages.nix     -> Integrates with settings for conditional package building
formatter.nix    -> Provides consistent formatting across all modules
dev-shells.nix   -> Offers development environments for working on the configuration
```

## Flake-Parts Compliance

This configuration follows flake-parts best practices:

- ✅ Proper module structure with `{ ... }: { ... }` pattern
- ✅ No redundant `flake.outputs` assignments  
- ✅ Clean separation of concerns
- ✅ Minimal custom flake attributes
- ✅ Proper path references
- ✅ perSystem usage for packages and formatters
- ✅ No empty placeholder modules
- ✅ Comprehensive module documentation

## Adding New Hosts

To add a new host, edit `hosts.nix`:

```nix
NewHost = mkHost {
  system = "x86_64-linux";
  hostName = "NewHost";
  modules = [
    # Add host-specific modules here
  ];
  extraArgs = {
    # Override settings for this host
    videoDriver = "intel";
  };
};
```

Then create the corresponding host configuration in `hosts/NewHost/configuration.nix`.

## Adding New Modules

When adding new modules:

1. **Follow naming conventions** - Use descriptive, lowercase names with hyphens
2. **Include comprehensive documentation** - Add detailed header comments explaining purpose, features, and usage
3. **Use appropriate flake-parts patterns**:
   - `perSystem` for system-specific functionality (packages, devShells, formatter)
   - `flake` for global outputs (nixosConfigurations, overlays, templates)
4. **Integrate with settings** - Reference `config.settings` for configuration options
5. **Maintain consistency** - Follow the established module structure and documentation format
6. **Update documentation** - Add the new module to this README with proper description

## Removed Components

The following components were removed during the flake-parts optimization:

- **`systems.nix`** - Deprecated in favor of the more flexible `hosts.nix`
- **`services.nix`** - Empty placeholder removed; service configuration handled via settings and host configs
- **`themes.nix`** - Empty placeholder removed; theme configuration handled via settings.nix
- **`hardware.nix`** - Empty placeholder removed; hardware configuration handled via settings.nix

This cleanup eliminates technical debt and reduces complexity while maintaining all functionality through the remaining, well-implemented modules.
