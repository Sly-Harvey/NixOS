{
  description = "A simple flake for an atomic system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-waybar-fix.url = "github:nixos/nixpkgs/c7b821ba2e1e635ba5a76d299af62821cbcb09f3";
    nur.url = "github:nix-community/NUR";
    nixvim.url = "github:Sly-Harvey/nixvim";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    /* Hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    }; */
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-stable,
    ...
  } @ inputs: let
    # User configuration
    username = "kepler"; # WARNING REPLACE THIS WITH YOUR USERNAME IF YOU ARE MANUALLY INSTALLING WITHOUT THE SCRIPT
    terminal = "alacritty"; # or kitty

    # System configuration
    locale = "en_GB.UTF-8"; # REPLACE THIS WITH YOUR LOCALE
    timezone = "Europe/London"; # REPLACE THIS WITH YOUR TIMEZONE
    hostname = "nixos"; # CHOOSE A HOSTNAME HERE (default is fine)

    arguments = {
      inherit
        pkgs-stable
        username
        terminal
        system
        locale
        timezone
        hostname
        ;
    };

    system = "x86_64-linux"; # most users will be on 64 bit pcs (unless yours is ancient)
    lib = nixpkgs.lib;
    pkgs-stable = _final: _prev: {
      stable = import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
        config.nvidia.acceptLicense = true;
      };
    };
  in {
    nixosConfigurations = {
      Default = lib.nixosSystem {
        inherit system;
        specialArgs =
          (arguments
            // {inherit inputs;})
          // inputs; # Expose all inputs and arguments
        modules = [
          ./hosts/Default/configuration.nix
        ];
      };
      Desktop = lib.nixosSystem {
        inherit system;
        specialArgs =
          (arguments
            // {
              inherit inputs;
              hostname = "NixOS-Desktop";
            })
          // inputs; # Expose all inputs and arguments
        modules = [
          ./hosts/Desktop/configuration.nix
        ];
      };
      Laptop = lib.nixosSystem {
        inherit system;
        specialArgs =
          (arguments
            // {
              inherit inputs;
              hostname = "NixOS-Laptop";
            })
          // inputs; # Expose all inputs and arguments
        modules = [
          ./hosts/Laptop/configuration.nix
        ];
      };
      Iso = lib.nixosSystem {
        # Build with: nix build .#nixosConfigurations.Iso.config.system.build.isoImage. (cpu intensive)
        inherit system;
        specialArgs =
          (arguments
            // {
              inherit inputs;
              hostname = "NixOS-Installer";
            })
          // inputs; # Expose all inputs and arguments
        modules = [
            ./hosts/LIVE-CD.nix
        ];
      };
    };
  };
}
