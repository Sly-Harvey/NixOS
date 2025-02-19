rec {
  default = {
    path = ./empty;
    description = "Empty development environment";
  };
  bun = {
    path = ./bun;
    description = "Bun development environment";
  };
  c-cpp = {
    path = ./c-cpp;
    description = "C/C++ development environment";
  };
  clojure = {
    path = ./clojure;
    description = "Clojure development environment";
  };
  csharp = {
    path = ./csharp;
    description = "C# development environment";
  };
  cue = {
    path = ./cue;
    description = "Cue development environment";
  };
  dhall = {
    path = ./dhall;
    description = "Dhall development environment";
  };
  elixir = {
    path = ./elixir;
    description = "Elixir development environment";
  };
  elm = {
    path = ./elm;
    description = "Elm development environment";
  };
  empty = {
    path = ./empty;
    description = "Empty dev template that you can customize at will";
  };
  gleam = {
    path = ./gleam;
    description = "Gleam development environment";
  };
  go = {
    path = ./go;
    description = "Go (Golang) development environment";
  };
  hashi = {
    path = ./hashi;
    description = "HashiCorp DevOps tools development environment";
  };
  haskell = {
    path = ./haskell;
    description = "Haskell development environment";
  };
  java = {
    path = ./java;
    description = "Java development environment";
  };
  jupyter = {
    path = ./jupyter;
    description = "Jupyter development environment";
  };
  kotlin = {
    path = ./kotlin;
    description = "Kotlin development environment";
  };
  latex = {
    path = ./latex;
    description = "LaTeX development environment";
  };
  lean4 = {
    path = ./lean4;
    description = "Lean 4 development environment";
  };
  nickel = {
    path = ./nickel;
    description = "Nickel development environment";
  };
  nim = {
    path = ./nim;
    description = "Nim development environment";
  };
  nix = {
    path = ./nix;
    description = "Nix development environment";
  };
  node = {
    path = ./node;
    description = "Node.js development environment";
  };
  ocaml = {
    path = ./ocaml;
    description = "OCaml development environment";
  };
  opa = {
    path = ./opa;
    description = "Open Policy Agent development environment";
  };
  php = {
    path = ./php;
    description = "PHP development environment";
  };
  platformio = {
    path = ./platformio;
    description = "PlatformIO development environment";
  };
  protobuf = {
    path = ./protobuf;
    description = "Protobuf development environment";
  };
  pulumi = {
    path = ./pulumi;
    description = "Pulumi development environment";
  };
  purescript = {
    path = ./purescript;
    description = "Purescript development environment";
  };
  python = {
    path = ./python;
    description = "Python development environment";
  };
  r = {
    path = ./r;
    description = "R development environment";
  };
  ruby = {
    path = ./ruby;
    description = "Ruby development environment";
  };
  rust = {
    path = ./rust;
    description = "Rust development environment";
  };
  rust-toolchain = {
    path = ./rust-toolchain;
    description = "Rust development environment with Rust version defined by a rust-toolchain.toml file";
  };
  scala = {
    path = ./scala;
    description = "Scala development environment";
  };
  shell = {
    path = ./shell;
    description = "Shell script development environment";
  };
  swi-prolog = {
    path = ./swi-prolog;
    description = "Swi-prolog development environment";
  };
  swift = {
    path = ./swift;
    description = "Swift development environment";
  };
  vlang = {
    path = ./vlang;
    description = "Vlang developent environment";
  };
  zig = {
    path = ./zig;
    description = "Zig development environment";
  };

  # Aliases
  c = c-cpp;
  cpp = c-cpp;
  rt = rust-toolchain;
}
