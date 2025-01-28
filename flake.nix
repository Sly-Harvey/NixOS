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
    settings = {
      # User configuration
      username = "kepler"; # no need to touch this since install.sh uses sed to replace this (otherwise if manually installing then you need to change this yourself)
      terminal = "kitty"; # kitty or alacritty
      terminalFileManager = "yazi"; # yazi or lf
      wallpaper = "cyberpunk.png"; # see modules/themes/wallpapers

      # System configuration
      system = "x86_64-linux"; # most users will be on 64 bit pcs
      gpuDriver = "nvidia"; # CHOOSE YOUR GPU DRIVERS (nvidia or amdgpu) THIS IS IMPORTANT
      hostname = "NixOS"; # CHOOSE A HOSTNAME HERE
      locale = "en_GB.UTF-8"; # CHOOSE YOUR LOCALE
      timezone = "Europe/London"; # CHOOSE YOUR TIMEZONE
      kbdLayout = "gb"; # CHOOSE YOUR KEYBOARD LAYOUT
      kbdVariant = "extd"; # CHOOSE YOUR KEYBOARD LAYOUT VARIANT (Can leave empty)
      consoleKeymap = "uk"; # CHOOSE YOUR CONSOLE KEYMAP (Affects the tty?)

      overlays = [
        inputs.nur.overlays.default
        (
          _final: _prev: {
            stable = import nixpkgs-stable {
              system = settings.system;
              config.allowUnfree = true;
              config.nvidia.acceptLicense = true;
            };
          }
        )
      ];
    };
  in
    {
      nixosConfigurations = {
        # Define systems here
        Default = nixpkgs.lib.nixosSystem {
          system = settings.system;
          specialArgs = (settings // {inherit inputs;}) // inputs;
          modules = [./hosts/Default/configuration.nix];
        };
      };
      devShells.${settings.system} = let
        pkgs = import nixpkgs {
          system = settings.system;
          config.allowUnfree = true;
          config.nvidia.acceptLicense = true;
          overlays = settings.overlays;
        };
      in {
        default = pkgs.mkShell {
          packages = with pkgs; [
            git
            nix
            home-manager
            figlet
            lolcat
          ];
          NIX_CONFIG = "extra-experimental-features = nix-command flakes";
        };
      };
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    }
    // {
      # To use a template do: nix flake init -t $templates#TEMPLATE_NAME"
      templates = rec {
        default = ./dev-shells/empty;
        bun = {
          path = ./dev-shells/bun;
          description = "Bun development environment";
        };
        c-cpp = {
          path = ./dev-shells/c-cpp;
          description = "C/C++ development environment";
        };
        clojure = {
          path = ./dev-shells/clojure;
          description = "Clojure development environment";
        };
        csharp = {
          path = ./dev-shells/csharp;
          description = "C# development environment";
        };
        cue = {
          path = ./dev-shells/cue;
          description = "Cue development environment";
        };
        dhall = {
          path = ./dev-shells/dhall;
          description = "Dhall development environment";
        };
        elixir = {
          path = ./dev-shells/elixir;
          description = "Elixir development environment";
        };
        elm = {
          path = ./dev-shells/elm;
          description = "Elm development environment";
        };
        empty = {
          path = ./dev-shells/empty;
          description = "Empty dev template that you can customize at will";
        };
        gleam = {
          path = ./dev-shells/gleam;
          description = "Gleam development environment";
        };
        go = {
          path = ./dev-shells/go;
          description = "Go (Golang) development environment";
        };
        hashi = {
          path = ./dev-shells/hashi;
          description = "HashiCorp DevOps tools development environment";
        };
        haskell = {
          path = ./dev-shells/haskell;
          description = "Haskell development environment";
        };
        java = {
          path = ./dev-shells/java;
          description = "Java development environment";
        };
        jupyter = {
          path = ./dev-shells/jupyter;
          description = "Jupyter development environment";
        };
        kotlin = {
          path = ./dev-shells/kotlin;
          description = "Kotlin development environment";
        };
        latex = {
          path = ./dev-shells/latex;
          description = "LaTeX development environment";
        };
        lean4 = {
          path = ./dev-shells/lean4;
          description = "Lean 4 development environment";
        };
        nickel = {
          path = ./dev-shells/nickel;
          description = "Nickel development environment";
        };
        nim = {
          path = ./dev-shells/nim;
          description = "Nim development environment";
        };
        nix = {
          path = ./dev-shells/nix;
          description = "Nix development environment";
        };
        node = {
          path = ./dev-shells/node;
          description = "Node.js development environment";
        };
        ocaml = {
          path = ./dev-shells/ocaml;
          description = "OCaml development environment";
        };
        opa = {
          path = ./dev-shells/opa;
          description = "Open Policy Agent development environment";
        };
        php = {
          path = ./dev-shells/php;
          description = "PHP development environment";
        };
        platformio = {
          path = ./dev-shells/platformio;
          description = "PlatformIO development environment";
        };
        protobuf = {
          path = ./dev-shells/protobuf;
          description = "Protobuf development environment";
        };
        pulumi = {
          path = ./dev-shells/pulumi;
          description = "Pulumi development environment";
        };
        purescript = {
          path = ./dev-shells/purescript;
          description = "Purescript development environment";
        };
        python = {
          path = ./dev-shells/python;
          description = "Python development environment";
        };
        r = {
          path = ./dev-shells/r;
          description = "R development environment";
        };
        ruby = {
          path = ./dev-shells/ruby;
          description = "Ruby development environment";
        };
        rust = {
          path = ./dev-shells/rust;
          description = "Rust development environment";
        };
        rust-toolchain = {
          path = ./dev-shells/rust-toolchain;
          description = "Rust development environment with Rust version defined by a rust-toolchain.toml file";
        };
        scala = {
          path = ./dev-shells/scala;
          description = "Scala development environment";
        };
        shell = {
          path = ./dev-shells/shell;
          description = "Shell script development environment";
        };
        swi-prolog = {
          path = ./dev-shells/swi-prolog;
          description = "Swi-prolog development environment";
        };
        swift = {
          path = ./dev-shells/swift;
          description = "Swift development environment";
        };
        vlang = {
          path = ./dev-shells/vlang;
          description = "Vlang developent environment";
        };
        zig = {
          path = ./dev-shells/zig;
          description = "Zig development environment";
        };

        # Aliases
        c = c-cpp;
        cpp = c-cpp;
        rt = rust-toolchain;
      };
    };
}
