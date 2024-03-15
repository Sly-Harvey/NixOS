{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixvim.url = "github:Sly-Harvey/nixvim";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  }@inputs: let
    username = "harvey"; # REPLACE THIS WITH YOUR USERNAME!!!!
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      # This is the only config you will have to change (Desktop and Laptop are for my personal use and may not work for you)
      nixos = lib.nixosSystem {
        inherit system;
        specialArgs = {inherit username inputs;} // inputs;
        modules = [
          ./hosts/Default
          #./home/programs/firefox/firefox-system.nix
        ];
      };
      Desktop = lib.nixosSystem {
        inherit system;
        specialArgs = let
          hostname = "NixOS-Desktop";
        in
          {inherit username hostname inputs;} // inputs;
        modules = [
          ./hosts/Desktop
        ];
      };
      Laptop = lib.nixosSystem {
        inherit system;
        specialArgs = let
          hostname = "NixOS-Laptop";
        in
          {inherit username hostname inputs;} // inputs;
        modules = [
          ./hosts/Laptop
        ];
      };
    };
    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    # or 'home-manager --flake .' for current user in current hostname
    homeConfigurations = {
      ${username} = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          ./home/home.nix
          {
            home = {
              username = username;
              homeDirectory = "/home/${username}";
              stateVersion = "23.11";
            };
          }
        ];
      };
    };
  };
}
