{
  description = "A simple flake for an atomic system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    nixvim.url = "github:Sly-Harvey/nixvim";
    hyprland.url = "github:hyprwm/Hyprland";
    Hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let

    username = "harvey"; # REPLACE THIS WITH YOUR USERNAME!!! (if manually installing, this is Required.)
    system = "x86_64-linux"; # REPLACE THIS WITH YOUR ARCHITECTURE (Rarely need to)
    locale = "en_GB.UTF-8"; # REPLACE THIS WITH YOUR LOCALE
    timezone = "Europe/London"; # REPLACE THIS WITH YOUR TIMEZONE

    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      # This is the only config you will have to change (Desktop and Laptop are for my personal use and may not work for you)
      nixos = lib.nixosSystem {
        inherit system;
        specialArgs = {inherit username locale timezone inputs;} // inputs;
        modules = [
          ./hosts/Default/configuration.nix
        ];
      };
      Desktop = lib.nixosSystem {
        inherit system;
        specialArgs = let
          hostname = "NixOS-Desktop";
        in
          {inherit username hostname inputs;} // inputs;
        modules = [
          ./hosts/Desktop/configuration.nix
        ];
      };
      Laptop = lib.nixosSystem {
        inherit system;
        specialArgs = let
          hostname = "NixOS-Laptop";
        in
          {inherit username hostname inputs;} // inputs;
        modules = [
          ./hosts/Laptop/configuration.nix
        ];
      };
      iso = lib.nixosSystem {
        inherit system;
        specialArgs =
          {
            username = "harvey";
            inherit inputs;
          }
          // inputs;
        modules = [
          ./hosts/ISO/configuration.nix
        ];
      };
      Test = lib.nixosSystem {
        inherit system;
        specialArgs = {inherit username locale timezone inputs;} // inputs;
        modules = [
          ./hosts/Test/configuration.nix
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    # or 'home-manager --flake .' for current user in current hostname
    #homeConfigurations = {
    #  ${username} = home-manager.lib.homeManagerConfiguration {
    #    pkgs = nixpkgs.legacyPackages.${system};
    #    modules = [
    #      ./home/home.nix
    #      {
    #        home = {
    #          username = username;
    #          homeDirectory = "/home/${username}";
    #          stateVersion = "23.11";
    #        };
    #      }
    #    ];
    #  };
    #};
  };
}
