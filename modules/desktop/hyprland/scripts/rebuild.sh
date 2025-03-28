#!/usr/bin/env bash

if [[ $EUID -eq 0 ]]; then
  echo "This script should not be executed as root! Exiting..."
  exit 1
fi

if [[ ! "$(grep -i nixos </etc/os-release)" ]]; then
  echo "This installation script only works on NixOS! Download an iso at https://nixos.org/download/"
  echo "Keep in mind that this script is not intended for use while in the live environment."
  exit 1
fi

scriptdir=$HOME/NixOS
currentUser=$(logname)

pushd "$HOME/NixOS" &>/dev/null || exit 0

# replace username variable in flake.nix with $USER
sed -i -e "s/username = \".*\"/username = \"$currentUser\"/" "$scriptdir/flake.nix"

if [ ! -f "$scriptdir/hosts/Default/hardware-configuration.nix" ]; then
  if [ -f "/etc/nixos/hardware-configuration.nix" ]; then
    for host in "$scriptdir"/hosts/*/; do
      host=${host%*/}
      cat "/etc/nixos/hardware-configuration.nix" >"$host/hardware-configuration.nix"
    done
  else
    # Generate new config
    clear
    nix develop "$scriptdir" --command bash -c "echo GENERATING CONFIG! | figlet -cklno | lolcat -F 0.3 -p 2.5 -S 300"
    for host in "$scriptdir"/hosts/*/; do
      host=${host%*/}
      sudo nixos-generate-config --show-hardware-config >"$host/hardware-configuration.nix"
    done
  fi
fi
git -C "$scriptdir" add hosts/Default/hardware-configuration.nix

# nh os switch "$scriptdir" --hostname Default
sudo nixos-rebuild switch --flake "$scriptdir#Default"
rm ~/NixOS/hosts/Default/hardware-configuration.nix &>/dev/null
git restore --staged ~/NixOS/hosts/Default/hardware-configuration.nix &>/dev/null

echo
read -rsn1 -p"Press any key to continue"

popd "$HOME/NixOS" &>/dev/null || exit 0
