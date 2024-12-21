#!/usr/bin/env bash

scriptdir=$(realpath "$(dirname "$0")")

for template in "$scriptdir"/*/; do
  template=${template%*/}
  # echo "use flake" > "$template/.envrc"
  # sed -i -e 's/github:nixos\/nixpkgs\/nixos-unstable/https:\/\/flakehub.com\/f\/NixOS\/nixpkgs\/0\.1\.*\.tar.gz/' "$template/flake.nix"
  sed -i -e 's/https:\/\/flakehub.com\/f\/NixOS\/nixpkgs\/0\.1\.*\.tar.gz/github:nixos\/nixpkgs\/nixos-unstable/' "$template/flake.nix"
done
