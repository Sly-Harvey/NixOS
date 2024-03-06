#!/usr/bin/env bash

# Check if running as root. If not root, script will exit
if [[ $EUID -ne 0 ]]; then
    echo "This script should be executed as root! Exiting..."
    exit 1
fi

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
mkdir -p $backupdir/new &> /dev/null
mkdir -p $backupdir/old &> /dev/null

# Backup existing config
mv /etc/nixos/* $backupdir/old &> /dev/null
rm -r /etc/nixos/.* &> /dev/null

# Clone github repo to /etc/nixos
nix shell --experimental-features "nix-command flakes" nixpkgs#git --command git clone --branch hosts https://github.com/Sly-Harvey/NixOS.git /etc/nixos
mv $backupdir /etc/nixos/backup
backupdir="/etc/nixos/backup"

printf "\n"
ask_yes_no "Do you want to use current hardware-configuration.nix? (Recommended)" replaceHardwareConfig

if [ "$replaceHardwareConfig" == "Y" ]; then
    rm /etc/nixos/nixos/hosts/default.nix &> /dev/null
    cp $(find $backupdir/old -iname 'hardware-configuration.nix') /etc/nixos/nixos/hosts/
    echo "{ imports = [ ./hardware-configuration.nix ]; }" >> /etc/nixos/nixos/hosts/default.nix
fi

nix-shell --command "git -C /etc/nixos add *"
# nix shell --experimental-features "nix-command flakes" nixpkgs#git --command git -C /etc/nixos add *

clear
nix-shell --command "echo BUILDING | figlet -cklnoW | lolcat -F 0.3 -p 2.5 -S 300"

nix-shell --command "sudo nixos-rebuild switch --flake /etc/nixos#nixos"
# sudo nix shell --experimental-features "nix-command flakes" nixpkgs#git --command sudo nixos-rebuild switch --flake /etc/nixos#nixos
