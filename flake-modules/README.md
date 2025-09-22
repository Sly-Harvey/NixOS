# Flake Modules

This directory contains the modular flake-parts configuration for this NixOS system. The configuration has been refactored from a monolithic `flake.nix` into focused, maintainable modules with enhanced modularity and reusability.

## Core Configuration Modules

### `settings.nix`
Enhanced user and system configuration settings with feature toggles and integration points:
- User preferences (username, editor, browser, terminal, etc.)
- Theme configuration (wallpapers, SDDM themes, color schemes)
- Hardware profiles (desktop, laptop, server)
- System configuration (hostname, locale, timezone, keyboard layout, etc.)
- Feature toggles for audio, gaming, development, and media stacks

### `hosts.nix` ⭐ **NEW**
Replaces `systems.nix` with a more flexible host management system:
- Helper functions for creating host configurations
- Shared configuration and host-specific overrides
- Easy addition of new hosts (laptop, server, etc.)
- Consistent argument passing and module loading

### `systems.nix` ⚠️ **DEPRECATED**
Legacy module kept for backward compatibility. Use `hosts.nix` instead.

## Feature Modules

### `dev-shells.nix`
Manages development shell templates from the `dev-shells/` directory. These provide ready-to-use development environments for various programming languages.

### `overlays.nix`
Handles Nixpkgs overlays that modify or add packages to the package set. References the `overlays/` directory.

### `packages.nix`
Manages custom packages using flake-parts' `perSystem` functionality. This provides better system-specific package handling for packages defined in the `pkgs/` directory.

### `formatter.nix`
Configures code formatting using treefmt-nix with nixfmt (RFC style) for consistent code style across all systems. Also includes formatting for shell scripts, markdown, and YAML files.

## New Modular Components

### `services.nix` ⭐ **NEW**
Centralized service configurations that can be shared across hosts:
- Syncthing file synchronization
- DLNA media server
- SSH server configuration
- Development services (Docker, libvirt)
- Easy enable/disable toggles for each service

### `themes.nix` ⭐ **NEW**
Centralized theme management system:
- Available wallpapers and SDDM themes
- Color scheme definitions (Catppuccin, Nord, Gruvbox)
- Theme helper functions
- Consistent theming across the system

### `hardware.nix` ⭐ **NEW**
Hardware profiles for different system types:
- **Desktop profile**: High performance, dedicated GPU support
- **Laptop profile**: Power efficiency, integrated graphics
- **Server profile**: Minimal graphics, maximum stability
- Video driver configurations per profile
- Hardware-specific feature sets

## Benefits of This Enhanced Structure

1. **Enhanced Modularity**: Each concern is separated into focused modules with clear responsibilities and interfaces.

2. **Hardware Profiles**: Different system types (desktop, laptop, server) can use optimized configurations automatically.

3. **Theme Management**: Centralized theming with consistent color schemes and easy theme switching.

4. **Service Management**: Common services can be easily enabled/disabled across different hosts.

5. **Feature Toggles**: Fine-grained control over system features to reduce compilation time and system bloat.

6. **Host Flexibility**: Easy addition of new hosts with shared configuration and host-specific overrides.

7. **Reusability**: Modules can be easily shared between different flake configurations or projects.

8. **Maintainability**: Changes to specific functionality only require editing the relevant module.

9. **Type Safety**: Better integration between modules with consistent interfaces and helper functions.

## Code Formatting

The configuration now uses treefmt-nix with multiple formatters:

- **nixfmt (RFC style)**: Formats Nix files with the new RFC-compliant style
- **shfmt**: Formats shell scripts with consistent indentation
- **mdformat**: Formats markdown files
- **yamlfmt**: Formats YAML files

### Usage

```bash
# Format all files
nix fmt

# Check formatting without making changes
nix run .#treefmt -- --fail-on-change

# Format specific files
nix run .#treefmt -- path/to/file.nix
```

## Usage Examples

### Adding a New Host

To add a laptop configuration:

1. Create `hosts/Laptop/` directory with `configuration.nix` and `hardware-configuration.nix`
2. Update `flake-modules/hosts.nix`:
   ```nix
   Laptop = mkHost {
     system = "x86_64-linux";
     hostName = "Laptop";
     extraArgs = {
       hardwareProfile = "laptop";
       videoDriver = "intel";
     };
   };
   ```

### Switching Themes

Update `flake-modules/settings.nix`:
```nix
wallpaper = "nature";
sddmTheme = "astronaut";
colorScheme = "nord";
```

### Enabling Features

Enable gaming stack in `flake-modules/settings.nix`:
```nix
features = {
  gaming = {
    enable = true;
    steam = true;
    lutris = true;
  };
};
```

### Using Hardware Profiles

The hardware profile automatically configures:
- Video drivers and packages
- Power management settings
- Audio configuration
- Hardware-specific features

Change profile in `flake-modules/settings.nix`:
```nix
hardwareProfile = "laptop"; # or "desktop", "server"
```

## Adding New Modules

To add a new flake-parts module:

1. Create a new `.nix` file in this directory
2. Follow the flake-parts module pattern:
   ```nix
   { inputs, config, ... }: {
     # Your module configuration here
     flake.myNewFeature = {
       # Configuration options
     };
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
