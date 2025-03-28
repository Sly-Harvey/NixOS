#!/usr/bin/env bash

# Check if running as root. If root, script will exit.
if [[ $EUID -eq 0 ]]; then
  echo "This script should not be executed as root! Exiting..."
  exit 1
fi

# Check if using NixOS. If not using NixOS, script will exit.
if [[ ! "$(grep -i nixos </etc/os-release)" ]]; then
  echo "This installation script only works on NixOS! Download an iso at https://nixos.org/download/"
  echo "Keep in mind that this script is not intended for use while in the live environment."
  exit 1
fi

scriptdir=$(realpath "$(dirname "$0")")
currentUser=$(logname)

pushd "$scriptdir" &>/dev/null || exit

# Delete dirs that conflict with home-manager (skip symlinks)
paths=(
  ~/.mozilla/firefox/profiles.ini
  ~/.zen/profiles.ini
  ~/.gtkrc-*
  ~/.config/gtk-*
  ~/.config/cava
)
for file in "${paths[@]}"; do
  for expanded in $file; do
    if [ -e "$expanded" ] && [ ! -L "$expanded" ]; then
      # echo "Removing: $expanded"
      sudo rm -rf "$expanded"
    fi
  done
done

# replace username variable in flake.nix with $USER
sed -i -e "s/username = \".*\"/username = \"$currentUser\"/" "$scriptdir/flake.nix"

# rm -f $scriptdir/hosts/Default/hardware-configuration.nix &>/dev/null
if [ ! -f "$scriptdir/hosts/Default/hardware-configuration.nix" ]; then
  if [ -f "/etc/nixos/hardware-configuration.nix" ]; then
    for host in "$scriptdir"/hosts/*/; do
      host=${host%*/}
      cat "/etc/nixos/hardware-configuration.nix" >"$host/hardware-configuration.nix"
    done
  else
    # Generate new config
    clear
    nix develop --experimental-features 'nix-command flakes' --command bash -c "echo GENERATING CONFIG! | figlet -cklno | lolcat -F 0.3 -p 2.5 -S 300"
    for host in "$scriptdir"/hosts/*/; do
      host=${host%*/}
      sudo nixos-generate-config --show-hardware-config >"$host/hardware-configuration.nix"
    done
  fi
fi

nix develop --experimental-features 'nix-command flakes' --command bash -c "git -C $scriptdir add hosts/Default/hardware-configuration.nix"

clear
nix develop --experimental-features 'nix-command flakes' --command bash -c "echo BUILDING! | figlet -cklnoW | lolcat -F 0.3 -p 2.5 -S 300"
nix develop --experimental-features 'nix-command flakes' --command bash -c "sudo nixos-rebuild switch --flake \"$scriptdir#Default\"" || exit 1
echo "success!"
echo "Make sure to reboot if this is your first time using this script!"

popd "$scriptdir" &>/dev/null || exit
