#!/usr/bin/env bash

# Check if running as root. If not root, script will exit
if [[ $EUID -ne 0 ]]; then
    echo "This script should be executed as root! Exiting..."
    exit 1
fi

scriptdir=$(realpath $(dirname $0))
currentUser=$(logname)
backupdir="/tmp/NixOS-backup"

colorize_prompt() {
    local color="$1"
    local message="$2"
    echo -n "${color}${message}$(tput sgr0)"
}
ask_yes_no() {
  if [[ ! -z "${!2}" ]]; then
    echo "$(colorize_prompt "$CAT"  "$1 (Preset): ${!2}")" 
    if [[ "${!2}" = [Yy] ]]; then
      return 0
    else
      return 1
    fi
  else
    eval "$2=''" 
  fi
    while true; do
        read -p "$(colorize_prompt "$CAT"  "$1 (y/n): ")" choice
        case "$choice" in
            [Yy]* ) eval "$2='Y'"; return 0;;
            [Nn]* ) eval "$2='N'"; return 1;;
            * ) echo "Please answer with y or n.";;
        esac
    done
}

# Delete dirs that conflict with home-manager
rm -rf ~/.gtkrc-*
rm -rf ~/.config/gtk-*

# Make backup dirs
rm -rf $backupdir &> /dev/null
mkdir -p $backupdir &> /dev/null

# Backup existing config
# mv /etc/nixos/* $backupdir &> /dev/null
mv $(find /etc/nixos -iname 'configuration.nix') $backupdir &> /dev/null 
mv $(find /etc/nixos -iname 'hardware-configuration.nix') $backupdir &> /dev/null
mv $(find /etc/nixos -iname 'home-pc.nix') $backupdir &> /dev/null
rm -rf /etc/nixos/* &> /dev/null
rm -rf /etc/nixos/.* &> /dev/null

# replace user variable in flake.nix with $USER
sed -i -e 's/user = \".*\"/user = \"'$currentUser'\"/' "/etc/nixos/flake.nix"
sed -i -e 's/user = \".*\"/user = \"'$currentUser'\"/' "$scriptdir/flake.nix"

printf "\n"
ask_yes_no "Do you want to use current hardware-configuration.nix? (Recommended)" replaceHardwareConfig

if [ "$replaceHardwareConfig" == "Y" ]; then
      rm -f $scriptdir/system/Default/hardware-configuration.nix &> /dev/null
    if [ -f $backupdir/hardware-configuration.nix ]; then
      cp $(find $backupdir -iname 'hardware-configuration.nix') $scriptdir/system/Default/hardware-configuration.nix
    elif [ -f $backupdir/home-pc.nix ]; then
      cp $(find $backupdir -iname 'home-pc.nix') $scriptdir/system/Default/hardware-configuration.nix
    else
      # Generate new config
      rm -rf /tmp/nixos-generated-config &> /dev/null
      mkdir -p /tmp/nixos-generated-config
      nixos-generate-config --dir /tmp/nixos-generated-config
      mv /tmp/nixos-generated-config/hardware-configuration.nix $scriptdir/system/Default/hardware-configuration.nix
      rm -rf /tmp/nixos-generated-config
    fi
fi

nix-shell --command "git -C $scriptdir add *"

clear
nix-shell --command "echo BUILDING! | figlet -cklnoW | lolcat -F 0.3 -p 2.5 -S 300"

nix-shell --command "sudo nixos-rebuild switch --flake $scriptdir#nixos"
