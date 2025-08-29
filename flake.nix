{
  description = "A simple flake for an atomic system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

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

    sqlmap = {
      url = "github:sqlmapproject/sqlmap";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, ... } @ inputs:
  let
    # ----- user/system settings you already had -----
    settings = {
      username = "sep";
      editor = "vscode";             # nixvim, vscode, nvchad, neovim, emacs (WIP)
      browser = "zen";               # firefox, floorp, zen
      terminal = "kitty";            # kitty, alacritty, wezterm
      terminalFileManager = "yazi";  # yazi or lf
      sddmTheme = "purple_leaves";   # astronaut, black_hole, purple_leaves, jake_the_dog, hyprland_kath
      wallpaper = "kurzgesagt";
      shell = "zsh";

      videoDriver = "amdgpu";        # nvidia, amdgpu or intel
      hostname = "NixOS";
      locale = "en_US.UTF-8";
      timezone = "America/Toronto";
      kbdLayout = "us";
      kbdVariant = "";
      consoleKeymap = "us";
    };

    systems = [ "x86_64-linux" "aarch64-linux" ];
    forAllSystems = nixpkgs.lib.genAttrs systems;

    # AppImage target is x86_64 only
    buildSystems = [ "x86_64-linux" ];
    forBuildSystems = nixpkgs.lib.genAttrs buildSystems;
  in
  {
    # dev templates & overlays you already had
    templates = import ./dev-shells;
    overlays  = import ./overlays { inherit inputs settings; };

    # formatter per system
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # ---------------- packages (includes stability-matrix + its updater bin) ----------------
    packages = forBuildSystems (system:
      let
        pkgs   = import nixpkgs { inherit system; };
        mypkgs = import ./pkgs { inherit pkgs settings; };
      in {
        # from pkgs/default.nix (must export stability-matrix & stability-matrix-updater)
        stability-matrix = mypkgs.stability-matrix;
        stability-matrix-updater = mypkgs.stability-matrix-updater;
        stability-matrix-pin = mypkgs.stability-matrix-pin;

        # convenience default
        default = mypkgs.stability-matrix;
      }
    );

    # ---------------- runnable apps ----------------
    apps = forBuildSystems (system: {
      stability-matrix = {
        type = "app";
        program = "${self.packages.${system}.stability-matrix}/bin/stability-matrix";
      };

      update-stability-matrix = {
        type = "app";
        program = "${self.packages.${system}.stability-matrix-updater}/bin/update-stability-matrix";
      };

      pin-stability-matrix = {
        type = "app";
        program = "${self.packages.${system}.stability-matrix-pin}/bin/pin-stability-matrix";
      };

      default = self.apps.${system}.stability-matrix;
    });

    # ---------------- NixOS host ----------------
    nixosConfigurations = {
      Default = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";                 # pick a concrete system here
        specialArgs = { inherit self inputs; } // settings;
        modules = [ ./hosts/Default/configuration.nix ];
      };
    };
  };
}
