#!/usr/bin/env bash

# Check if running as root. If not root, script will exit
if [[ $EUID -ne 0 ]]; then
	echo "This script should be executed as root! Exiting..."
	exit 1
fi

scriptdir=$(realpath $(dirname $0))
currentUser=$(logname)

# Delete dirs that conflict with home-manager
rm -f ~/.mozilla/firefox/profiles.ini
rm -rf ~/.gtkrc-*
rm -rf ~/.config/gtk-*
rm -rf ~/.config/cava

# replace user variable in flake.nix with $USER
sed -i -e 's/username = \".*\"/username = \"'$currentUser'\"/' $scriptdir/flake.nix

rm -f $scriptdir/hosts/Default/hardware-configuration.nix &>/dev/null
if ! cp $(find /etc/nixos -iname 'hardware-configuration.nix') $scriptdir/hosts/Default/hardware-configuration.nix; then
	# Generate new config
	clear
	nix-shell --command "echo GENERATING CONFIG! | figlet -cklno | lolcat -F 0.3 -p 2.5 -S 300"
	nixos-generate-config --show-hardware-config >$scriptdir/hosts/Default/hardware-configuration.nix
fi

nix-shell --command "sudo -u $currentUser git -C $scriptdir add *"

clear
nix-shell --command "echo BUILDING! | figlet -cklnoW | lolcat -F 0.3 -p 2.5 -S 300"
nix-shell --command "sudo nixos-rebuild switch --flake $scriptdir#nixos --show-trace && rm -rf $backupdir"
