#!/usr/bin/env bash
sudo rm -r /etc/nixos/* &> /dev/null && sudo rm -r /etc/nixos/.* &> /dev/null && sudo nixos-generate-config
echo "Cleaned /etc/nixos"
