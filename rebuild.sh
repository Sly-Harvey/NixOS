#!/usr/bin/env bash
scriptdir=$(realpath $(dirname $0))
currentUser=$(logname)
sed -i -e 's/user = \".*\"/user = \"'$currentUser'\"/' $scriptdir/flake.nix
sudo nixos-rebuild switch --flake .
