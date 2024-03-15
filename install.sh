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
rm -f ~/.mozilla/firefox/profiles.ini
rm -rf ~/.gtkrc-*
rm -rf ~/.config/gtk-*
rm -rf ~/.config/cava

# Make backup dirs
rm -rf $backupdir &> /dev/null
mkdir -p $backupdir &> /dev/null

# Delete Default hardware-configuration.nix
rm -f $scriptdir/hosts/Default/hardware-configuration.nix &> /dev/null

# Backup existing config
# mv /etc/nixos/* $backupdir &> /dev/null
cp $(find /etc/nixos -iname 'configuration.nix') $backupdir &> /dev/null 
cp $(find /etc/nixos -iname 'hardware-configuration.nix') $backupdir &> /dev/null
cp $(find /etc/nixos -iname 'home-pc.nix') $backupdir &> /dev/null
#rm -rf /etc/nixos/* &> /dev/null
#rm -rf /etc/nixos/.* &> /dev/null

# replace user variable in flake.nix with $USER
sed -i -e 's/username = \".*\"/username = \"'$currentUser'\"/' $scriptdir/flake.nix
#sed -i -e 's/username = \".*\"/username = \"'$currentUser'\"/' "/etc/nixos/flake.nix"

if [ "$1" == "--Copy-Hardware" ]; then
    replaceHardwareConfig="Y"
else
    printf "\n"
    ask_yes_no "Do you want to use current hardware-configuration.nix in /etc/nixos? (Recommended)" replaceHardwareConfig
fi

if [ "$replaceHardwareConfig" == "Y" ]; then
      rm -f $scriptdir/hosts/Default/hardware-configuration.nix &> /dev/null
    if [ -f $backupdir/hardware-configuration.nix ]; then
      cp $(find $backupdir -iname 'hardware-configuration.nix') $scriptdir/hosts/Default/hardware-configuration.nix
    elif [ -f $backupdir/home-pc.nix ]; then
      cp $(find $backupdir -iname 'home-pc.nix') $scriptdir/hosts/Default/hardware-configuration.nix
    else
      # Generate new config
      clear
      nix-shell --command "echo GENERATING CONFIG! | figlet -cklno | lolcat -F 0.3 -p 2.5 -S 300"
      nixos-generate-config --show-hardware-config > $scriptdir/hosts/Default/hardware-configuration.nix

      #rm -rf /tmp/nixos-generated-config &> /dev/null
      #mkdir -p /tmp/nixos-generated-config
      #nixos-generate-config --dir /tmp/nixos-generated-config
      #mv /tmp/nixos-generated-config/hardware-configuration.nix $scriptdir/hosts/Default/hardware-configuration.nix
      #rm -rf /tmp/nixos-generated-config
    fi
fi

nix-shell --command "sudo -u $currentUser git -C $scriptdir add *"

clear
nix-shell --command "echo BUILDING! | figlet -cklnoW | lolcat -F 0.3 -p 2.5 -S 300"

nix-shell --command "sudo nixos-rebuild switch --flake $scriptdir#nixos --show-trace && rm -rf $backupdir"
