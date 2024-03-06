{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    nix
    home-manager
    git
  ];
  NIX_CONFIG = "extra-experimental-features = nix-command flakes";
}
