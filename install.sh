#!/usr/bin/env bash

# If in the live environment then start the live-install.sh script
if [ -d "/iso" ] || [ "$(findmnt -o FSTYPE -n /)" = "tmpfs" ]; then
  sudo ./live-install.sh
  exit 0
fi

# Check if running as root. If root, script will exit.
if [[ $EUID -eq 0 ]]; then
  echo "This script should not be executed as root! Exiting..."
  exit 1
fi

# Check if using NixOS. If not using NixOS, script will exit.
if [[ ! "$(grep -i nixos </etc/os-release)" ]]; then
  echo "This installation script only works on NixOS! Download an iso at https://nixos.org/download/"
  echo "You can either use this script in the live environment or booted into a system."
  exit 1
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

currentUser=$(logname)

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

# replace username variable in variables.nix with $USER
sudo sed -i -e "s/username = \".*\"/username = \"$currentUser\"/" "./hosts/Default/variables.nix"

# rm -f ./hosts/Default/hardware-configuration.nix &>/dev/null
if [ -f "/etc/nixos/hardware-configuration.nix" ]; then
  cat "/etc/nixos/hardware-configuration.nix" | sudo tee "./hosts/Default/hardware-configuration.nix" >/dev/null
elif [ -f "/etc/nixos/hosts/Default/hardware-configuration.nix" ]; then
  cat "/etc/nixos/hosts/Default/hardware-configuration.nix" | sudo tee "./hosts/Default/hardware-configuration.nix" >/dev/null
else
  sudo nixos-generate-config --show-hardware-config >"$flake/hosts/Default/hardware-configuration.nix"
fi

sudo git -C . add hosts/Default/hardware-configuration.nix

# clear
sudo nixos-rebuild switch --flake .#Default && \
    echo -e "${GREEN}Success!${NC}" && \
    echo "Make sure to reboot if this is your first time using this script!" || \
    exit 1
