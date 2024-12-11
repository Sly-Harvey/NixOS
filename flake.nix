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
    self,
    nixpkgs,
    nixpkgs-stable,
    ...
  } @ inputs: let

    # User configuration
    username = "kepler"; # WARNING REPLACE THIS WITH YOUR USERNAME IF MANUALLY INSTALLING
    terminal = "kitty"; # alacritty or kitty
    wallpaper = "cyberpunk.png"; # see modules/themes/wallpapers

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
        wallpaper
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
  }
  // { # To use a template do: nix flake init -t $templates#TEMPLATE_NAME"
    templates = rec {
      default = ./dev-templates/empty;
      bun = {
        path = ./dev-templates/bun;
        description = "Bun development environment";
      };
      c-cpp = {
        path = ./dev-templates/c-cpp;
        description = "C/C++ development environment";
      };
      clojure = {
        path = ./dev-templates/clojure;
        description = "Clojure development environment";
      };
      csharp = {
        path = ./dev-templates/csharp;
        description = "C# development environment";
      };
      cue = {
        path = ./dev-templates/cue;
        description = "Cue development environment";
      };
      dhall = {
        path = ./dev-templates/dhall;
        description = "Dhall development environment";
      };
      elixir = {
        path = ./dev-templates/elixir;
        description = "Elixir development environment";
      };
      elm = {
        path = ./dev-templates/elm;
        description = "Elm development environment";
      };
      empty = {
        path = ./dev-templates/empty;
        description = "Empty dev template that you can customize at will";
      };
      gleam = {
        path = ./dev-templates/gleam;
        description = "Gleam development environment";
      };
      go = {
        path = ./dev-templates/go;
        description = "Go (Golang) development environment";
      };
      hashi = {
        path = ./dev-templates/hashi;
        description = "HashiCorp DevOps tools development environment";
      };
      haskell = {
        path = ./dev-templates/haskell;
        description = "Haskell development environment";
      };
      java = {
        path = ./dev-templates/java;
        description = "Java development environment";
      };
      jupyter = {
        path = ./dev-templates/jupyter;
        description = "Jupyter development environment";
      };
      kotlin = {
        path = ./dev-templates/kotlin;
        description = "Kotlin development environment";
      };
      latex = {
        path = ./dev-templates/latex;
        description = "LaTeX development environment";
      };
      lean4 = {
        path = ./dev-templates/lean4;
        description = "Lean 4 development environment";
      };
      nickel = {
        path = ./dev-templates/nickel;
        description = "Nickel development environment";
      };
      nim = {
        path = ./dev-templates/nim;
        description = "Nim development environment";
      };
      nix = {
        path = ./dev-templates/nix;
        description = "Nix development environment";
      };
      node = {
        path = ./dev-templates/node;
        description = "Node.js development environment";
      };
      ocaml = {
        path = ./dev-templates/ocaml;
        description = "OCaml development environment";
      };
      opa = {
        path = ./dev-templates/opa;
        description = "Open Policy Agent development environment";
      };
      php = {
        path = ./dev-templates/php;
        description = "PHP development environment";
      };
      platformio = {
        path = ./dev-templates/platformio;
        description = "PlatformIO development environment";
      };
      protobuf = {
        path = ./dev-templates/protobuf;
        description = "Protobuf development environment";
      };
      pulumi = {
        path = ./dev-templates/pulumi;
        description = "Pulumi development environment";
      };
      purescript = {
        path = ./dev-templates/purescript;
        description = "Purescript development environment";
      };
      python = {
        path = ./dev-templates/python;
        description = "Python development environment";
      };
      r = {
        path = ./dev-templates/r;
        description = "R development environment";
      };
      ruby = {
        path = ./dev-templates/ruby;
        description = "Ruby development environment";
      };
      rust = {
        path = ./dev-templates/rust;
        description = "Rust development environment";
      };
      rust-toolchain = {
        path = ./dev-templates/rust-toolchain;
        description = "Rust development environment with Rust version defined by a rust-toolchain.toml file";
      };
      scala = {
        path = ./dev-templates/scala;
        description = "Scala development environment";
      };
      shell = {
        path = ./dev-templates/shell;
        description = "Shell script development environment";
      };
      swi-prolog = {
        path = ./dev-templates/swi-prolog;
        description = "Swi-prolog development environment";
      };
      swift = {
        path = ./dev-templates/swift;
        description = "Swift development environment";
      };
      vlang = {
        path = ./dev-templates/vlang;
        description = "Vlang developent environment";
      };
      zig = {
        path = ./dev-templates/zig;
        description = "Zig development environment";
      };

      # Aliases
      c = c-cpp;
      cpp = c-cpp;
      rt = rust-toolchain;
    };
  };
}
