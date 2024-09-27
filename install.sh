#!/usr/bin/env bash

# Check if running as root. If root, script will exit.
if [[ $EUID -eq 0 ]]; then
	echo "This script should not be executed as root! Exiting..."
	exit 1
fi

# Check if using NixOS. If not using NixOS, script will exit.
if [[ ! "$(grep -i nixos < /etc/os-release)" ]]; then
	echo "This installation script only works on NixOS! Download an iso at https://nixos.org/download/"
  echo "Keep in mind that this script is not intended for use while in the live environment."
	exit 1
fi

scriptdir=$(realpath "$(dirname "$0")")
currentUser=$(logname)

pushd "$scriptdir"&> /dev/null || exit

# Delete dirs that conflict with home-manager
sudo rm -f ~/.mozilla/firefox/profiles.ini
sudo rm -rf ~/.gtkrc-*
sudo rm -rf ~/.config/gtk-*
sudo rm -rf ~/.config/cava

# replace username variable in flake.nix with $USER
sed -i -e 's/username = \".*\"/username = \"'$currentUser'\"/' "$scriptdir/flake.nix"

# rm -f $scriptdir/hosts/Default/hardware-configuration.nix &>/dev/null
if [ -f "/etc/nixos/hardware-configuration.nix" ]; then
  for host in "$scriptdir"/hosts/*/ ; do
    host=${host%*/}
    cat "/etc/nixos/hardware-configuration.nix" > "$host/hardware-configuration.nix"
  done
else
	# Generate new config
	clear
  nix-shell --command "echo GENERATING CONFIG! | figlet -cklno | lolcat -F 0.3 -p 2.5 -S 300"	
  for host in "$scriptdir"/hosts/*/ ; do
    host=${host%*/}
    sudo nixos-generate-config --show-hardware-config > "$host/hardware-configuration.nix"
  done
fi

nix-shell --command "git -C $scriptdir add *"

clear
nix-shell --command "echo BUILDING! | figlet -cklnoW | lolcat -F 0.3 -p 2.5 -S 300"
nix-shell --command "sudo nixos-rebuild switch --flake "$scriptdir#Default" || exit 1"
echo "success!"
echo "Make sure to reboot if this is your first time using this script!"

popd "$scriptdir" &> /dev/null || exit
