#!/usr/bin/env bash
scriptdir=$(realpath $(dirname $0))
currentUser=$(logname)
sed -i -e 's/username = \".*\"/username = \"'$currentUser'\"/' $scriptdir/flake.nix
sudo nixos-rebuild switch --flake .#nixos
