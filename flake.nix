{
  description = "A simple flake for an atomic system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nur.url = "github:nix-community/NUR";
    nixvim = {
      url = "github:Sly-Harvey/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
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
    username = "kepler"; # WARNING REPLACE THIS WITH YOUR USERNAME IF MANUALLY INSTALLING
    terminal = "kitty"; # alacritty or kitty

    # System configuration
    hostname = "nixos"; # CHOOSE A HOSTNAME HERE (default is fine)
    locale = "en_GB.UTF-8"; # REPLACE THIS WITH YOUR LOCALE
    timezone = "Europe/London"; # REPLACE THIS WITH YOUR TIMEZONE
    kbdLayout = "uk"; # REPLACE THIS WITH YOUR KEYBOARD LAYOUT

    arguments = {
      inherit
        pkgs-stable
        username
        terminal
        system
        locale
        timezone
        hostname
        kbdLayout
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
    };
  };
}
