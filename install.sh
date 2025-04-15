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

# replace username variable in flake.nix with $USER
sed -i -e "s/username = \".*\"/username = \"$currentUser\"/" "./flake.nix"

# rm -f ./hosts/Default/hardware-configuration.nix &>/dev/null
if [ ! -f "./hosts/Default/hardware-configuration.nix" ]; then
  if [ -f "/etc/nixos/hardware-configuration.nix" ]; then
    cat "/etc/nixos/hardware-configuration.nix" >"./hosts/Default/hardware-configuration.nix"
  elif [ -f "/etc/nixos/hosts/Default/hardware-configuration.nix" ]; then
    cat "/etc/nixos/hosts/Default/hardware-configuration.nix" >"./hosts/Default/hardware-configuration.nix"
  else
    # Generate new config
    clear
    nix develop --experimental-features 'nix-command flakes' --command bash -c "echo GENERATING CONFIG! | figlet -cklno | lolcat -F 0.3 -p 2.5 -S 300"
    sudo nixos-generate-config --show-hardware-config >"./hosts/Default/hardware-configuration.nix"
  fi
fi

nix develop --experimental-features 'nix-command flakes' --command bash -c "git -C . add hosts/Default/hardware-configuration.nix"

clear
nix develop --experimental-features 'nix-command flakes' --command bash -c "echo BUILDING! | figlet -cklnoW | lolcat -F 0.3 -p 2.5 -S 300"
nix develop --experimental-features 'nix-command flakes' --command bash -c "sudo nixos-rebuild switch --flake .#Default" || exit 1
echo "success!"
echo "Make sure to reboot if this is your first time using this script!"
