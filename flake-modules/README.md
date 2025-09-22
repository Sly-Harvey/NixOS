# Flake Modules

This directory contains the modular flake-parts configuration for the NixOS system.

## Module Structure

### Core Modules

- **`settings.nix`** - Central configuration settings (user preferences, system config, feature toggles)
- **`hosts.nix`** - Host definitions and NixOS system configurations
- **`formatter.nix`** - Code formatting configuration using treefmt-nix

### Feature Modules

- **`packages.nix`** - Custom package definitions (perSystem)
- **`overlays.nix`** - Nixpkgs overlays
- **`dev-shells.nix`** - Development shell templates

### Configuration Modules

- **`services.nix`** - Service configuration options (placeholder)
- **`themes.nix`** - Theme configuration options (placeholder)
- **`hardware.nix`** - Hardware configuration options (placeholder)

## Usage

The main configuration is controlled through `settings.nix`, which provides:

- User preferences (editor, browser, terminal)
- Theme settings (wallpaper, SDDM theme)
- Hardware settings (video driver)
- Feature toggles (audio, gaming, development, media)

## Flake-Parts Compliance

This configuration follows flake-parts best practices:

- ✅ Proper module structure with `{ ... }: { ... }` pattern
- ✅ No redundant `flake.outputs` assignments
- ✅ Clean separation of concerns
- ✅ Minimal custom flake attributes
- ✅ Proper path references
- ✅ perSystem usage for packages and formatters

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

