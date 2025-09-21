# Flake Modules

This directory contains the modular flake-parts configuration for this NixOS system. The configuration has been refactored from a monolithic `flake.nix` into focused, maintainable modules.

## Module Structure

### `settings.nix`
Contains user and system configuration settings that were previously defined in the main `flake.nix`. This includes:
- User preferences (username, editor, browser, terminal, etc.)
- System configuration (hostname, locale, timezone, keyboard layout, etc.)
- Hardware settings (video driver, themes, wallpapers)

### `systems.nix`
Handles `nixosConfigurations` for different hosts. Currently defines the "Default" system configuration and passes the settings and inputs to the host modules.

### `dev-shells.nix`
Manages development shell templates from the `dev-shells/` directory. These provide ready-to-use development environments for various programming languages.

### `overlays.nix`
Handles Nixpkgs overlays that modify or add packages to the package set. References the `overlays/` directory.

### `packages.nix`
Manages custom packages using flake-parts' `perSystem` functionality. This provides better system-specific package handling for packages defined in the `pkgs/` directory.

### `formatter.nix`
Configures code formatting using Alejandra for consistent Nix code style across all systems.

## Benefits of This Structure

1. **Modularity**: Each concern is separated into its own file, making the configuration easier to understand and maintain.

2. **Reusability**: Modules can be easily shared between different flake configurations or disabled/enabled as needed.

3. **System Handling**: flake-parts provides better system architecture with `perSystem` for system-specific configurations.

4. **Maintainability**: Changes to specific functionality (like adding a new package or overlay) only require editing the relevant module.

5. **Extensibility**: New modules can be easily added by creating a new file and importing it in the main `flake.nix`.

## Adding New Modules

To add a new flake-parts module:

1. Create a new `.nix` file in this directory
2. Follow the flake-parts module pattern:
   ```nix
   { inputs, config, ... }: {
     # Your module configuration here
   }
   ```
3. Import the module in the main `flake.nix` imports list
4. Document the module's purpose in this README

## Migration Notes

This configuration maintains backward compatibility with the original structure:
- Host configurations in `hosts/` remain unchanged
- Module imports in host configurations work as before
- Settings are passed through `specialArgs` as before
- All original functionality is preserved

## Flake-parts Resources

- [flake-parts Documentation](https://flake.parts/)
- [Getting Started Guide](https://flake.parts/getting-started.html)
- [Options Reference](https://flake.parts/options/flake-parts.html)

