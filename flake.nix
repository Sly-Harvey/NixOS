# NixOS/flake.nix
{
  description = "A simple flake for my atomic system";

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

    athena-nix = {
      url = "github:Athena-OS/athena-nix";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
    settings = {
      # User configuration
      username = "sep"; # automatically set with install.sh and live-install.sh
      editor = "vscode"; # nixvim, vscode, nvchad, neovim, emacs (WIP)
      browser = "zen"; # firefox, floorp, zen
      terminal = "kitty"; # kitty, alacritty, wezterm
      terminalFileManager = "yazi"; # yazi or lf
      sddmTheme = "purple_leaves"; # astronaut, black_hole, purple_leaves, jake_the_dog, hyprland_kath
      wallpaper = "kurzgesagt"; # see modules/themes/wallpapers
      shell = "zsh"; # zsh or fish

      # System configuration
      videoDriver = "amdgpu"; # CHOOSE YOUR GPU DRIVERS (nvidia, amdgpu or intel)
      hostname = "NixOS"; # CHOOSE A HOSTNAME HERE
      locale = "en_US.UTF-8"; # CHOOSE YOUR LOCALE
      timezone = "America/Toronto"; # CHOOSE YOUR TIMEZONE
      kbdLayout = "us"; # CHOOSE YOUR KEYBOARD LAYOUT
      kbdVariant = ""; # CHOOSE YOUR KEYBOARD VARIANT (Can leave empty)
      consoleKeymap = "us"; # CHOOSE YOUR CONSOLE KEYMAP (Affects the tty?)
      athenaRole = [ "all" ];  # or e.g. [ "web" "wireless" "crypto" ]
    };

    systems = [ 
      "x86_64-linux" 
      "aarch64-linux" 
      ];
    forAllSystems = nixpkgs.lib.genAttrs systems;

    # AppImage target is x86_64 only
    buildSystems = [ "x86_64-linux" ];
    forBuildSystems = nixpkgs.lib.genAttrs buildSystems;
  in
  {
    # dev templates & overlays you already had
    templates = import ./dev-shells;
    overlays = import ./overlays {inherit inputs settings;};
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
        #default = mypkgs.stability-matrix;
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

      sync-athena-cyber = let
        pkgs   = import nixpkgs { inherit system; };
        script = pkgs.writeShellApplication {
          name = "sync-athena-cyber";
          runtimeInputs = with pkgs; [ nix rsync coreutils git ];
          text = ''
            set -euo pipefail
            FLAKE="$HOME/NixOS"
            cd "$FLAKE"

            echo "[sync-athena-cyber] updating input: athena-nix"
            nix flake update athena-nix >/dev/null

            echo "[sync-athena-cyber] resolving athena-nix store path"
            ATHENA="$(nix eval --impure --raw "$FLAKE#nixosConfigurations.Default._module.args.inputs.athena-nix")"

            echo "[sync-athena-cyber] syncing $ATHENA/nixos/modules/cyber -> $FLAKE/modules/athena/cyber"
            mkdir -p "$FLAKE/modules/athena/cyber"
            rsync -a --delete "$ATHENA/nixos/modules/cyber/" "$FLAKE/modules/athena/cyber/"

            echo "[sync-athena-cyber] done"
          '';
        };
      in {
        type = "app";
        program = "${script}/bin/sync-athena-cyber";
      };

      # --- ADDED: sync + rebuild switch ---
      sync-and-switch = let
        pkgs   = import nixpkgs { inherit system; };
        script = pkgs.writeShellApplication {
          name = "sync-and-switch";
          runtimeInputs = with pkgs; [ nix rsync coreutils sudo git ];
          text = ''
            set -euo pipefail
            FLAKE="$HOME/NixOS"
            nix run "$FLAKE#sync-athena-cyber"
            echo "[sync-and-switch] rebuilding…"
            sudo nixos-rebuild switch --flake "$FLAKE#Default" --impure
          '';
        };
      in {
        type = "app";
        program = "${script}/bin/sync-and-switch";
      };

      #default = self.apps.${system}.stability-matrix;
    });

    # ---------------- NixOS host ----------------
    nixosConfigurations = {
      Default = nixpkgs.lib.nixosSystem {
        system = forAllSystems (system: system);
        specialArgs = {inherit self inputs outputs;} // settings;
        modules = [./hosts/Default/configuration.nix];
      };
    };
  };
}
