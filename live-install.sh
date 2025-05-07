#!/usr/bin/env bash

# Interactive NixOS installer for my NixOS flake
# This script is automatically called from install.sh
# But you can run it manually too in the NixOS live environment.

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Check if running in NixOS live ISO
if [ ! -d "/iso" ] || [ "$(findmnt -o FSTYPE -n /)" != "tmpfs" ]; then
  echo -e "${RED}Error: This script must be run in the NixOS live ISO environment.${NC}"
  echo "Please boot the NixOS live ISO and try again."
  exit 1
fi

# Ensure script is run as root
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root. Try sudo $0" >&2
  exit 1
fi

export NIX_CONFIG="experimental-features = nix-command flakes"

echo -e "${GREEN}Welcome to my NixOS installer!${NC}"

check_editors() {
  local editors=("vim" "nano" "vi")
  for editor in "${editors[@]}"; do
    if command -v "$editor" &>/dev/null; then
      echo "$editor"
      return
    fi
  done
  echo "none"
}

select_disk() {
  if [ "$partitioning" = "manual" ]; then
    echo -e "\n${GREEN}Select the disk to launch cfdisk with:${NC}"
  else
    echo -e "\n${GREEN}Select the disk to install NixOS on:${NC}"
  fi
  echo "Available disks:"
  lsblk -d -o NAME,SIZE,MODEL | grep -v loop
  while true; do
    read -p "Enter disk name (e.g., sda, nvme0n1): " disk
    if [ -b "/dev/$disk" ]; then
      break
    else
      echo -e "${RED}Invalid disk. Please try again.${NC}"
    fi
  done
}

cleanup() {
  echo -e "\n${GREEN}Cleaning up...${NC}"
  if [ -n "$home_mapped_device" ]; then
    umount /mnt/home 2>/dev/null || true
    if [ "$home_encrypted" = "yes" ]; then
      cryptsetup luksClose luks-home 2>/dev/null || true
    fi
  fi
  umount -R /mnt
  if [ -n "$part_swap" ]; then
    swapoff "/dev/$part_swap"
  fi
  if [ "$luks_enabled" = "yes" ]; then
    cryptsetup luksClose luks-root
  fi
}

# Start of prompts
echo -e "\n${GREEN}Let's configure your NixOS installation.${NC}"

# Username
echo -e "\n${GREEN}Set up a user account:${NC}"
while true; do
  read -p "Enter username: " username
  if [[ "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
    break
  else
    echo -e "${RED}Invalid username. Use lowercase letters, numbers, underscores, or hyphens.${NC}"
  fi
done

# User password
echo -e "\n${GREEN}Set password for $username:${NC}"
while true; do
  read -s -p "Enter password: " password
  echo
  read -s -p "Confirm password: " password_confirm
  echo
  if [ "$password" = "$password_confirm" ]; then
    if [ -z "$password" ]; then
      echo -e "${RED}Password cannot be empty. Try again.${NC}"
    else
      break
    fi
  else
    echo -e "${RED}Passwords do not match. Try again.${NC}"
  fi
done

# GPU Drivers
echo -e "\n${GREEN}Choose GPU Drivers:${NC}"
echo "1) nvidia"
echo "2) amdgpu"
echo "3) intel"
while true; do
  read -p "Enter choice (1, 2 or 3): " driver_choice
  case $driver_choice in
    1)
      sudo sed -i -e "s/videoDriver = \".*\"/videoDriver = \"nvidia\"/" "./flake.nix"
      break;;
    2)
      sudo sed -i -e "s/videoDriver = \".*\"/videoDriver = \"amdgpu\"/" "./flake.nix"
      break;;
    3)
      sudo sed -i -e "s/videoDriver = \".*\"/videoDriver = \"intel\"/" "./flake.nix"
      break;;
    *) echo -e "${RED}Invalid choice. Enter 1 or 2.${NC}";;
  esac
done

# Set editor for flake.nix
default_editor=$(check_editors)
if [ "$default_editor" = "none" ]; then
  echo -e "${RED}No editors found (vim, nano, vi). Falling back to installation without editing flake.nix.${NC}"
  editor="none"
else
  echo -e "\n${GREEN}Choose an editor to customize flake.nix:${NC}"
  echo "1) $default_editor (default)"
  echo "2) vim"
  echo "3) nano"
  echo "4) vi"
  echo "5) Skip editing"
  while true; do
    read -p "Enter choice (1-5, default 1): " editor_choice
    editor_choice=${editor_choice:-1}
    case $editor_choice in
      1) editor="$default_editor"; break;;
      2) editor="vim +52"; break;;
      3) editor="nano +52"; break;;
      4) editor="vi +52"; break;;
      5) editor="none"; break;;
      *) echo -e "${RED}Invalid choice. Enter 1-5.${NC}";;
    esac
    if [ "$editor" != "none" ] && ! command -v "${editor%% *}" &>/dev/null; then
      echo -e "${RED}Editor $editor not found. Please choose another.${NC}"
    else
      break
    fi
  done
fi

# Edit flake.nix
if [ "$editor" != "none" ]; then
  echo -e "\n${GREEN}Opening flake.nix in $editor for customization...${NC}"
  echo "Edit the 'settings' block to customize username, editor, browser, hostname, etc."
  echo "Save and exit when done (e.g., :wq for vim & vi, Ctrl+O then Ctrl+X for nano)."
  read -p "Press Enter to continue..."
  $editor ./flake.nix
else
  echo -e "${GREEN}Skipping flake.nix editing as requested or no editor available.${NC}"
fi

# Partitioning method
echo -e "\n${GREEN}Choose partitioning method:${NC}"
echo "1) Automatic (for single OS or clean disk)"
echo "2) Manual (for dual-boot or custom layouts, launches cfdisk)"
while true; do
  read -p "Enter choice (1 or 2): " part_choice
  case $part_choice in
    1) partitioning="auto"; break;;
    2) partitioning="manual"; break;;
    *) echo -e "${RED}Invalid choice. Enter 1 or 2.${NC}";;
  esac
done

# Display summary and confirm
echo -e "\n${GREEN}Summary:${NC}"
echo "Username: $username"
echo "User Password: [hidden]"
echo "Partitioning: $partitioning"
if [ "$partitioning" = "manual" ]; then
  echo 
  echo "Please create partitions, including EFI, root, and optionally home and swap. Write and quit when done."
  read -p "Launch cfdisk for manual partitioning? (Y/n): " confirm
else
  select_disk
  echo "Warning: This will erase all data on chosen drive."
  read -p "Proceed with installation? (Y/n): " confirm
fi
if [[ "$confirm" =~ ^[nN]$ ]]; then
  echo -e "${RED}Installation aborted.${NC}"
  exit 1
fi

# Handle partitioning
echo -e "\n${GREEN}Setting up disk partitions...${NC}"
if [ "$partitioning" = "auto" ]; then
  # Automatic partitioning: 512M EFI, 2G swap, rest for root
  echo "Creating automatic partition layout..."
  wipefs -a "/dev/$disk"
  parted -s "/dev/$disk" \
    mklabel gpt \
    mkpart primary fat32 1MiB 513MiB \
    set 1 esp on \
    mkpart primary linux-swap 513MiB 2561MiB \
    mkpart primary 2561MiB 100%
  if [[ "/dev/$disk" =~ nvme ]]; then
    part_boot="${disk}p1"
    part_swap="${disk}p2"
    part_root="${disk}p3"
  else
    part_boot="${disk}1"
    part_swap="${disk}2"
    part_root="${disk}3"
  fi
else
  select_disk
  echo "Launching cfdisk for manual partitioning..."
  cfdisk "/dev/$disk"
  echo -e "\n${GREEN}Partitioning complete. Please specify partition assignments:${NC}"
  echo "Available partitions:"
  lsblk -o NAME,SIZE,MODEL | grep -v loop
  # Prompt for EFI partition
  while true; do
    read -p "Enter EFI partition (e.g., sda1, nvme0n1p1): " part_boot
    if [ -b "/dev/$part_boot" ]; then
      break
    else
      echo -e "${RED}Invalid partition. Try again.${NC}"
    fi
  done
  # Prompt for root partition
  while true; do
    read -p "Enter root partition (e.g., sda2, nvme0n1p2): " part_root
    if [ -b "/dev/$part_root" ] && [ "/dev/$part_root" != "/dev/$part_boot" ]; then
      break
    else
      echo -e "${RED}Invalid or same as EFI partition. Try again.${NC}"
    fi
  done
  # Prompt for home partition (optional)
  echo "Home partition is optional. Leave blank to skip."
  read -p "Enter home partition (e.g., sda3, nvme0n1p3 or blank): " part_home
  if [ -n "$part_home" ]; then
    if [ -b "/dev/$part_home" ] && [ "/dev/$part_home" != "/dev/$part_boot" ] && [ "/dev/$part_home" != "/dev/$part_root" ]; then
      : # Valid partition
    else
      echo -e "${RED}Invalid home partition or same as EFI or root. Skipping separate home.${NC}"
      part_home=""
    fi
  else
    part_home=""
  fi
  # Prompt for swap partition (optional)
  echo "Swap partition is optional. Leave blank to skip."
  read -p "Enter swap partition (e.g., sda4, nvme0n1p4, or blank): " part_swap
  if [ -n "$part_swap" ] && [ ! -b "/dev/$part_swap" ]; then
    echo -e "${RED}Invalid swap partition. Skipping swap.${NC}"
    part_swap=""
  elif [ -n "$part_swap" ] && { [ "/dev/$part_swap" = "/dev/$part_boot" ] || [ "/dev/$part_swap" = "/dev/$part_root" ] || [ "/dev/$part_swap" = "/dev/$part_home" ]; }; then
    echo -e "${RED}Swap cannot be same as EFI, root, or home. Skipping swap.${NC}"
    part_swap=""
  fi
fi

# Filesystem for root partition
echo -e "\n${GREEN}Choose a filesystem for root partition:${NC}"
echo "1) ext4"
echo "2) btrfs"
while true; do
  read -p "Enter choice (1 or 2): " fs_choice
  case $fs_choice in
    1) filesystem="ext4"; break;;
    2) filesystem="btrfs"; break;;
    *) echo -e "${RED}Invalid choice. Enter 1 or 2.${NC}";;
  esac
done

# LUKS encryption for root
echo -e "\n${GREEN}Enable LUKS encryption for root partition?${NC}"
echo "1) Yes"
echo "2) No"
while true; do
  read -p "Enter choice (1 or 2): " luks_choice
  case $luks_choice in
    1) luks_enabled="yes"; break;;
    2) luks_enabled="no"; break;;
    *) echo -e "${RED}Invalid choice. Enter 1 or 2.${NC}";;
  esac
done

# LUKS password for root (if enabled)
if [ "$luks_enabled" = "yes" ]; then
  echo -e "\n${GREEN}Set LUKS encryption password for root:${NC}"
  while true; do
    read -s -p "Enter LUKS password: " luks_password
    echo
    read -s -p "Confirm LUKS password: " luks_password_confirm
    echo
    if [ "$luks_password" = "$luks_password_confirm" ]; then
      if [ -z "$luks_password" ]; then
        echo -e "${RED}LUKS password cannot be empty. Try again.${NC}"
      else
        break
      fi
    else
      echo -e "${RED}Passwords do not match. Try again.${NC}"
    fi
  done
fi

# Set up LUKS for root (if enabled)
if [ "$luks_enabled" = "yes" ]; then
  echo -e "\n${GREEN}Setting up LUKS encryption for root...${NC}"
  echo -n "$luks_password" | cryptsetup luksFormat "/dev/$part_root" -
  echo -n "$luks_password" | cryptsetup luksOpen "/dev/$part_root" luks-root -
  root_device="/dev/mapper/luks-root"
else
  root_device="/dev/$part_root"
fi

# Set up home partition (manual partitioning only)
if [ "$partitioning" = "manual" ] && [ -n "$part_home" ]; then
  echo -e "\n${GREEN}Setting up home partition...${NC}"
  home_device="/dev/$part_home"
  # Check if it's a LUKS device
  if blkid -p "$home_device" | grep -q 'TYPE="crypto_LUKS"'; then
    echo "Home partition is encrypted with LUKS."
    # Ask for password to unlock
    while true; do
      read -s -p "Enter LUKS password to unlock home partition: " home_luks_password
      echo
      if echo -n "$home_luks_password" | cryptsetup luksOpen "$home_device" luks-home -; then
        break
      else
        echo -e "${RED}Incorrect password. Try again.${NC}"
      fi
    done
    home_mapped_device="/dev/mapper/luks-home"
    home_encrypted="yes"
  else
    # Not encrypted
    home_encrypted="no"
    # Check if it has a filesystem
    if blkid "$home_device" | grep -q "TYPE="; then
      echo "Home partition has a filesystem."
      read -p "Do you want to reuse it without formatting? (Y/n): " reuse_home
      if [[ ! "$reuse_home" =~ ^[nN]$ ]]; then
        # Reuse without formatting
        home_mapped_device="$home_device"
      else
        echo -e "\n${GREEN}Enable LUKS encryption for home partition?${NC}"
        echo "1) Yes"
        echo "2) No"
        while true; do
          read -p "Enter choice (1 or 2): " home_luks_choice
          case $home_luks_choice in
            1) home_luks_enabled="yes"; break;;
            2) home_luks_enabled="no"; break;;
            *) echo -e "${RED}Invalid choice. Enter 1 or 2.${NC}";;
          esac
        done
        if [ "$home_luks_enabled" = "yes" ]; then
          echo -e "\n${GREEN}Setting up LUKS for home partition...${NC}"
          if [ "$luks_enabled" = "yes" ]; then
            echo "Do you want to use the same password as the root partition?"
            echo "1) Yes"
            echo "2) No"
            while true; do
              read -p "Enter choice (1 or 2): " same_password_choice
              case $same_password_choice in
                1) home_luks_password="$luks_password"; break;;
                2) break;;
                *) echo -e "${RED}Invalid choice. Enter 1 or 2.${NC}";;
              esac
            done
          fi
          if [ -z "$home_luks_password" ]; then
            while true; do
              read -s -p "Enter LUKS password for home partition: " home_luks_password
              echo
              read -s -p "Confirm LUKS password: " home_luks_password_confirm
              echo
              if [ "$home_luks_password" = "$home_luks_password_confirm" ]; then
                if [ -z "$home_luks_password" ]; then
                  echo -e "${RED}Password cannot be empty. Try again.${NC}"
                else
                  break
                fi
              else
                echo -e "${RED}Passwords do not match. Try again.${NC}"
              fi
            done
          fi
          echo -n "$home_luks_password" | cryptsetup luksFormat "$home_device" -
          echo -n "$home_luks_password" | cryptsetup luksOpen "$home_device" luks-home -
          home_mapped_device="/dev/mapper/luks-home"
          home_encrypted="yes"
        else
          home_mapped_device="$home_device"
        fi
        echo "Formatting home partition with $filesystem"
        if [ "$filesystem" = "ext4" ]; then
          mkfs.ext4 -F "$home_mapped_device"
        elif [ "$filesystem" = "btrfs" ]; then
          mkfs.btrfs -f "$home_mapped_device"
        fi
      fi
    else
      echo "Home partition has no filesystem."
      echo -e "\n${GREEN}Enable LUKS encryption for home partition?${NC}"
      echo "1) Yes"
      echo "2) No"
      while true; do
        read -p "Enter choice (1 or 2): " home_luks_choice
        case $home_luks_choice in
          1) home_luks_enabled="yes"; break;;
          2) home_luks_enabled="no"; break;;
          *) echo -e "${RED}Invalid choice. Enter 1 or 2.${NC}";;
        esac
      done
      if [ "$home_luks_enabled" = "yes" ]; then
        echo -e "\n${GREEN}Setting up LUKS for home partition...${NC}"
        if [ "$luks_enabled" = "yes" ]; then
          echo "Do you want to use the same password as the root partition?"
          echo "1) Yes"
          echo "2) No"
          while true; do
            read -p "Enter choice (1 or 2): " same_password_choice
            case $same_password_choice in
              1) home_luks_password="$luks_password"; break;;
              2) break;;
              *) echo -e "${RED}Invalid choice. Enter 1 or 2.${NC}";;
            esac
          done
        fi
        if [ -z "$home_luks_password" ]; then
          while true; do
            read -s -p "Enter LUKS password for home partition: " home_luks_password
            echo
            read -s -p "Confirm LUKS password: " home_luks_password_confirm
            echo
            if [ "$home_luks_password" = "$home_luks_password_confirm" ]; then
              if [ -z "$home_luks_password" ]; then
                echo -e "${RED}Password cannot be empty. Try again.${NC}"
              else
                break
              fi
            else
              echo -e "${RED}Passwords do not match. Try again.${NC}"
            fi
          done
        fi
        echo -n "$home_luks_password" | cryptsetup luksFormat "$home_device" -
        echo -n "$home_luks_password" | cryptsetup luksOpen "$home_device" luks-home -
        home_mapped_device="/dev/mapper/luks-home"
        home_encrypted="yes"
      else
        home_mapped_device="$home_device"
      fi
      echo "Formatting home partition with $filesystem"
      if [ "$filesystem" = "ext4" ]; then
        mkfs.ext4 -F "$home_mapped_device"
      elif [ "$filesystem" = "btrfs" ]; then
        mkfs.btrfs -f "$home_mapped_device"
      fi
    fi
  fi
fi

# Format partitions
echo -e "\n${GREEN}Formatting partitions...${NC}"
mkfs.fat -F32 "/dev/$part_boot"
if [ "$filesystem" = "ext4" ]; then
  mkfs.ext4 -F "$root_device"
elif [ "$filesystem" = "btrfs" ]; then
  mkfs.btrfs -f "$root_device"
fi
if [ -n "$part_swap" ]; then
  mkswap "/dev/$part_swap"
fi

# Mount filesystems
echo -e "\n${GREEN}Mounting filesystems...${NC}"
mount "$root_device" /mnt
mkdir -p /mnt/boot
mount "/dev/$part_boot" /mnt/boot
if [ -n "$home_mapped_device" ]; then
  mkdir -p /mnt/home
  mount "$home_mapped_device" /mnt/home
fi
if [ -n "$part_swap" ]; then
  swapon "/dev/$part_swap"
fi
echo "Done."

# Generate hardware configuration
echo -e "\n${GREEN}Generating hardware configuration...${NC}"
nixos-generate-config --root /mnt --show-hardware-config > ./hosts/Default/hardware-configuration.nix
echo "Done."

# Replace username variable in flake.nix
sed -i -e "s/username = \".*\"/username = \"$username\"/" ./flake.nix
git add *

# Copy flake to /etc/nixos
# echo -e "\n${GREEN}Copying flake to /etc/nixos...${NC}"
mkdir -p /mnt/etc/nixos
cp -r ./ /mnt/etc/nixos
# echo "Done."

# Run nixos-install
echo -e "\n${GREEN}Installing system...${NC}"
nixos-install --flake /mnt/etc/nixos#Default --no-root-passwd
nixos-enter --root /mnt -c "echo $password | passwd --stdin $username"

# Copy flake to ~/NixOS
echo -e "\n${GREEN}Copying flake to /home/$username/NixOS...${NC}"
mkdir -p "/mnt/home/$username/NixOS"
cp -r ./ "/mnt/home/$username/NixOS/"
uid=$(awk -F: -v user="$username" '$1 == user {print $3}' /mnt/etc/passwd)
gid=$(awk -F: -v user="$username" '$1 == user {print $4}' /mnt/etc/passwd)
chown -R "$uid:$gid" "/mnt/home/$username/NixOS"
echo "Done."

# Run cleanup
cleanup

echo -e "\n${GREEN}Installation complete! Reboot to start your new NixOS system.${NC}"
