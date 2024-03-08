{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    firefox-addons = { url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons"; inputs.nixpkgs.follows = "nixpkgs"; };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      user = "harvey"; # REPLACE THIS WITH YOUR USERNAME!!!!
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
          specialArgs.user = user;
          modules = [
            ./nixos/configuration.nix
            #./home/programs/firefox/firefox-system.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; user = user; };
              home-manager.users.${user} = {
                imports = [
                  ./home/home.nix
                ];
              };
            }
          ];
        };
      };
      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      # or 'home-manager --flake .' for current user in current hostname
      homeConfigurations = {
        ${user} = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            ./home/home.nix
            {
              home = {
                username = "${user}";
                homeDirectory = "/home/${user}";
                stateVersion = "23.11";
              };
            }
          ];
        };
      };
    };
}
