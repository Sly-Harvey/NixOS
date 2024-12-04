#!/usr/bin/env bash

pushd "$HOME/NixOS" &>/dev/null || exit 0

~/NixOS/install.sh
rm ~/NixOS/hosts/Default/hardware-configuration.nix &>/dev/null
git restore --staged ~/NixOS/hosts/Default/hardware-configuration.nix &>/dev/null

echo
read -rsn1 -p"Press any key to continue"

popd "$HOME/NixOS" &>/dev/null || exit 0
