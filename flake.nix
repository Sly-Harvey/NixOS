{
  description = "A simple flake for an atomic system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:Sly-Harvey/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    betterfox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
    };
    thunderbird-catppuccin = {
      url = "github:catppuccin/thunderbird";
      flake = false;
    };
    zen-browser = {
      url = "github:maximoffua/zen-browser.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvchad4nix = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-stable,
    ...
  } @ inputs: let
    settings = {
      # User configuration
      username = "error"; # no need to touch this since install.sh uses sed to replace this (otherwise if manually installing then you need to change this yourself)
      editor = "nixvim"; # nixvim, vscode, emacs, nvchad, neovim
      browser = "floorp"; # firefox, floorp, zen
      terminal = "kitty"; # kitty, alacritty, wezterm
      terminalFileManager = "yazi"; # yazi or lf
      wallpaper = "Train.jpg"; # see modules/themes/wallpapers

      # System configuration
      gpuDriver = "nvidia"; # CHOOSE YOUR GPU DRIVERS (nvidia or amdgpu) THIS IS IMPORTANT
      hostname = "NixOS"; # CHOOSE A HOSTNAME HERE
      locale = "en_GB.UTF-8"; # CHOOSE YOUR LOCALE
      timezone = "Europe/London"; # CHOOSE YOUR TIMEZONE
      kbdLayout = "gb"; # CHOOSE YOUR KEYBOARD LAYOUT
      kbdVariant = "extd"; # CHOOSE YOUR KEYBOARD VARIANT (Can leave empty)
      consoleKeymap = "uk"; # CHOOSE YOUR CONSOLE KEYMAP (Affects the tty?)

      overlays = [
        inputs.nur.overlays.default
        (
          _final: _prev: {
            stable = import nixpkgs-stable {
              system = forAllSystems (system: system);
              config.allowUnfree = true;
              config.nvidia.acceptLicense = true;
            };
          }
        )
      ];
    };

    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    templates = import ./dev-shells;
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    nixosConfigurations = {
      Default = nixpkgs.lib.nixosSystem {
        system = forAllSystems (system: system);
        specialArgs = (settings // {inherit inputs;}) // inputs;
        modules = [./hosts/Default/configuration.nix];
      };
    };
    devShells = forAllSystems (system: let
      pkgs = import nixpkgs {
        system = system;
        config.allowUnfree = true;
        config.nvidia.acceptLicense = true;
        # overlays = settings.overlays;
      };
    in {
      default = pkgs.mkShellNoCC {
        packages = with pkgs; [
          git
          nix
          figlet
          lolcat
        ];
        NIX_CONFIG = "experimental-features = nix-command flakes";
      };
    });
  };
}
