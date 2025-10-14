#!/usr/bin/env bash

# Interactive NixOS installer for my NixOS flake
# This script is automatically called from install.sh
# But you can run it manually too in the NixOS live environment.

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to display status messages
info() {
  echo -e "\n${GREEN}$1${NC}"
}

warn() {
  echo -e "${YELLOW}$1${NC}"
}

error() {
  echo -e "${RED}Error: $1${NC}" >&2
}

# Check if running in NixOS live ISO
if [ ! -d "/iso" ] && [ "$(findmnt -o FSTYPE -n /)" != "tmpfs" ]; then
  error "This script must be run in the NixOS live ISO environment."
  echo "Please boot the NixOS live ISO and try again."
  exit 1
fi

# Ensure script is run as root
if [ "$(id -u)" != "0" ]; then
  error "This script must be run as root. Try sudo $0"
  exit 1
fi

# Enable nix flakes
export NIX_CONFIG="experimental-features = nix-command flakes"

info "Welcome to my NixOS installer!"

# Host management functions
list_hosts() {
  local hosts=()
  for host_dir in ./hosts/*/; do
    if [ -d "$host_dir" ]; then
      host_name=$(basename "$host_dir")
      hosts+=("$host_name")
    fi
  done
  printf '%s\n' "${hosts[@]}"
}

create_new_host() {
  local new_name="$1"
  local template="$2"

  if [ -z "$new_name" ]; then
    error "Host name cannot be empty"
    return 1
  fi

  if [ -d "./hosts/$new_name" ]; then
    error "Host '$new_name' already exists"
    return 1
  fi

  if [ ! -d "./hosts/$template" ]; then
    error "Template host '$template' does not exist"
    return 1
  fi

  info "Creating new host '$new_name' from template '$template'..."
  cp -r "./hosts/$template" "./hosts/$new_name" || {
    error "Failed to copy template"
    return 1
  }

  # Remove old hardware config
  rm -f "./hosts/$selected_host/hardware-configuration.nix"

  # Update hostname in the new host's variables.nix if it exists
  if [ -f "./hosts/$new_name/variables.nix" ]; then
    sed -i -e "s/hostname = \".*\"/hostname = \"$new_name\"/" "./hosts/$new_name/variables.nix"
  fi

  echo "Host '$new_name' created successfully."
  return 0
}

add_host_to_flake() {
  local host_name="$1"

  info "Adding host '$host_name' to flake.nix..."

  # Check if host already exists in flake
  if grep -q "\"$host_name\"" flake.nix; then
    warn "Host '$host_name' already exists in flake.nix"
    return 0
  fi

  # Find the nixosConfigurations section and add the new host
  awk -v host="$host_name" '
    /nixosConfigurations = {/ {
      print
      getline
      print
      print "        " host " = mkHost \"" host "\";"
      next
    }
    { print }
  ' flake.nix >flake.nix.tmp && mv flake.nix.tmp flake.nix

  info "Host '$host_name' added to flake.nix"
  return 0
}

# Find available text editors
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

# Disk selection function
select_disk() {
  if [ "$partitioning" = "manual" ]; then
    info "Select the disk to launch cfdisk with:"
  else
    info "Select the disk to install NixOS on:"
  fi

  echo "Available disks:"
  lsblk -d -o NAME,SIZE,MODEL | grep -v loop

  while true; do
    read -p "Enter disk name (e.g., sda, nvme0n1): " disk
    if [ -b "/dev/$disk" ]; then
      break
    else
      error "Invalid disk. Please try again."
    fi
  done
}

# Clean up mounts at exit or if interrupted
cleanup() {
  info "Cleaning up..."

  # Unmount everything
  if [ -n "$home_mapped_device" ]; then
    umount /mnt/home 2>/dev/null || true
    if [ "$home_encrypted" = "yes" ]; then
      cryptsetup luksClose luks-home 2>/dev/null || true
    fi
  fi

  umount -R /mnt 2>/dev/null || true

  if [ -n "$part_swap" ]; then
    swapoff "/dev/$part_swap" 2>/dev/null || true
  fi

  if [ "$luks_enabled" = "yes" ]; then
    cryptsetup luksClose luks-root 2>/dev/null || true
  fi

  echo "Cleanup complete."
}

# Register cleanup on exit
trap cleanup EXIT

# Start of interactive configuration
info "Let's configure your NixOS installation."

# Host selection
info "NixOS Configuration Host Selection"

available_hosts=($(list_hosts))

if [ ${#available_hosts[@]} -eq 0 ]; then
  error "No hosts found in hosts directory"
  exit 1
fi

echo -e "\nAvailable hosts:"
for i in "${!available_hosts[@]}"; do
  echo "  $((i + 1))) ${available_hosts[$i]}"
done
echo "  n) Create new host"

while true; do
  read -p "Select host to use [Default: 1]: " host_choice
  host_choice=${host_choice:-1}

  if [[ "$host_choice" == "n" ]] || [[ "$host_choice" == "N" ]]; then
    # Create new host
    read -p "Enter name for new host: " new_host_name

    # Validate host name (alphanumeric, hyphens, and underscores only)
    if [[ ! "$new_host_name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
      error "Invalid host name. Use only letters, numbers, hyphens, and underscores."
      continue
    fi

    echo "Select template host:"
    for i in "${!available_hosts[@]}"; do
      echo "  $((i + 1))) ${available_hosts[$i]}"
    done

    read -p "Template choice [Default: 1]: " template_choice
    template_choice=${template_choice:-1}

    if [[ "$template_choice" =~ ^[0-9]+$ ]] && [ "$template_choice" -ge 1 ] && [ "$template_choice" -le ${#available_hosts[@]} ]; then
      template_host="${available_hosts[$((template_choice - 1))]}"

      if create_new_host "$new_host_name" "$template_host"; then
        selected_host="$new_host_name"
        add_host_to_flake "$selected_host"
        break
      fi
    else
      error "Invalid template choice"
    fi

  elif [[ "$host_choice" =~ ^[0-9]+$ ]] && [ "$host_choice" -ge 1 ] && [ "$host_choice" -le ${#available_hosts[@]} ]; then
    selected_host="${available_hosts[$((host_choice - 1))]}"
    break
  else
    error "Invalid choice. Please try again."
  fi
done

info "Using host: $selected_host"

# Username setup
info "Set up a user account:"
while true; do
  read -p "Enter username: " username
  if [[ "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
    break
  else
    error "Invalid username. Use lowercase letters, numbers, underscores, or hyphens."
  fi
done

# User password
info "Set password for $username:"
while true; do
  read -s -p "Enter password: " password
  echo
  read -s -p "Confirm password: " password_confirm
  echo
  if [ "$password" = "$password_confirm" ]; then
    if [ -z "$password" ]; then
      error "Password cannot be empty. Try again."
    else
      break
    fi
  else
    error "Passwords do not match. Try again."
  fi
done

# GPU Drivers selection
info "Choose GPU Drivers:"
echo "1) nvidia"
echo "2) amdgpu"
echo "3) intel"
while true; do
  read -p "Enter choice (1, 2 or 3): " driver_choice
  case $driver_choice in
  1)
    sed -i -e "s/videoDriver = \".*\"/videoDriver = \"nvidia\"/" "./hosts/$selected_host/variables.nix"
    break
    ;;
  2)
    sed -i -e "s/videoDriver = \".*\"/videoDriver = \"amdgpu\"/" "./hosts/$selected_host/variables.nix"
    break
    ;;
  3)
    sed -i -e "s/videoDriver = \".*\"/videoDriver = \"intel\"/" "./hosts/$selected_host/variables.nix"
    break
    ;;
  *) error "Invalid choice. Enter 1, 2, or 3." ;;
  esac
done

# Editor selection for customizing variables.nix
default_editor=$(check_editors)
if [ "$default_editor" = "none" ]; then
  warn "No editors found (vim, nano, vi). Falling back to installation without editing variables.nix."
  editor="none"
else
  info "Choose an editor to customize variables.nix:"
  echo "1) $default_editor (default)"
  echo "2) vim"
  echo "3) nano"
  echo "4) vi"
  echo "5) Skip editing"

  while true; do
    read -p "Enter choice (1-5, default 1): " editor_choice
    editor_choice=${editor_choice:-1}

    case $editor_choice in
    1)
      editor="$default_editor"
      break
      ;;
    2)
      editor="vim +52"
      break
      ;;
    3)
      editor="nano +52"
      break
      ;;
    4)
      editor="vi +52"
      break
      ;;
    5)
      editor="none"
      break
      ;;
    *) error "Invalid choice. Enter 1-5." ;;
    esac

    if [ "$editor" != "none" ] && ! command -v "${editor%% *}" &>/dev/null; then
      error "Editor $editor not found. Please choose another."
    else
      break
    fi
  done
fi

# Edit variables.nix
if [ "$editor" != "none" ]; then
  info "Opening variables.nix in $editor for customization..."
  echo "Edit desktop, editor, browser, hostname, etc."
  echo "Save and exit when done (e.g., :wq for vim & vi, Ctrl+O then Ctrl+X for nano)."
  read -p "Press Enter to continue..."
  $editor "./hosts/$selected_host/variables.nix" || {
    warn "Editor exited with an error. Continuing with default settings."
  }
else
  info "Skipping variables.nix editing as requested or no editor available."
fi

clear

# Partitioning method selection
info "Choose partitioning method:"
echo "1) Automatic (for single OS or clean disk)"
echo "2) Manual (for dual-boot or custom layouts, launches cfdisk)"
while true; do
  read -p "Enter choice (1 or 2): " part_choice
  case $part_choice in
  1)
    partitioning="auto"
    break
    ;;
  2)
    partitioning="manual"
    break
    ;;
  *) error "Invalid choice. Enter 1 or 2." ;;
  esac
done

# Display installation summary and confirm
info "Summary:"
echo "Host: $selected_host"
echo "Username: $username"
echo "User Password: [hidden]"
echo "Partitioning: $partitioning"

if [ "$partitioning" = "manual" ]; then
  echo
  echo "Please create partitions, including EFI, root, and optionally home and swap. Write and quit when done."
  read -p "Launch cfdisk for manual partitioning? (Y/n): " confirm
else
  select_disk
  warn "Warning: This will erase all data on /dev/$disk."
  read -p "Proceed with installation? (Y/n): " confirm
fi

if [[ "$confirm" =~ ^[nN]$ ]]; then
  error "Installation aborted by user."
  exit 1
fi

# Handle disk partitioning
info "Setting up disk partitions..."
if [ "$partitioning" = "auto" ]; then
  # Get swap size preference
  info "Configure swap partition size:"
  echo "Recommendation: For systems with <= 8GB RAM, use RAM size x 2. For > 8GB RAM, use 8GB or less."
  echo "Enter size in GB (e.g., 2 for 2GB, 4 for 4GB) or 0 for no swap"

  while true; do
    read -p "Swap size in GB [default: 2]: " swap_size
    # Set default if empty
    swap_size=${swap_size:-2}

    # Validate input is a number
    if [[ "$swap_size" =~ ^[0-9]+$ ]]; then
      break
    else
      error "Please enter a valid number."
    fi
  done

  # Convert GB to MiB
  swap_size_mib=$((swap_size * 1024))
  efi_end_mib=513 # EFI partition end point

  # Automatic partitioning: 512M EFI, swap_size GB swap, rest for root
  echo "Creating automatic partition layout with ${swap_size}GB swap..."

  # Safety check before wiping
  if mount | grep -q "/dev/$disk"; then
    error "Disk /dev/$disk is currently mounted! Please unmount all partitions first."
    lsblk "/dev/$disk"
    exit 1
  fi

  # Wipe and create partitions
  wipefs -af "/dev/$disk" || {
    error "Failed to wipe disk signatures"
    exit 1
  }

  if [ "$swap_size" -eq 0 ]; then
    # No swap partition
    parted -s "/dev/$disk" \
      mklabel gpt \
      mkpart primary fat32 1MiB ${efi_end_mib}MiB \
      set 1 esp on \
      mkpart primary ${efi_end_mib}MiB 100% || {
      error "Partitioning failed! Check if disk is in use."
      exit 1
    }

    # Determine partition names based on device type
    if [[ "/dev/$disk" =~ nvme ]]; then
      part_boot="${disk}p1"
      part_root="${disk}p2"
    else
      part_boot="${disk}1"
      part_root="${disk}2"
    fi

    part_swap="" # No swap

  else
    # With swap partition
    swap_end_mib=$((efi_end_mib + swap_size_mib))

    parted -s "/dev/$disk" \
      mklabel gpt \
      mkpart primary fat32 1MiB ${efi_end_mib}MiB \
      set 1 esp on \
      mkpart primary linux-swap ${efi_end_mib}MiB ${swap_end_mib}MiB \
      mkpart primary ${swap_end_mib}MiB 100% || {
      error "Partitioning failed! Check if disk is in use."
      exit 1
    }

    # Determine partition names based on device type
    if [[ "/dev/$disk" =~ nvme ]]; then
      part_boot="${disk}p1"
      part_swap="${disk}p2"
      part_root="${disk}p3"
    else
      part_boot="${disk}1"
      part_swap="${disk}2"
      part_root="${disk}3"
    fi
  fi
else
  # Manual partitioning
  select_disk
  echo "Launching cfdisk for manual partitioning..."
  cfdisk "/dev/$disk" || {
    error "cfdisk failed. Disk might be in use or damaged."
    exit 1
  }

  # Prompt for partition assignments
  info "Partitioning complete. Please specify partition assignments:"
  echo "Available partitions:"
  lsblk -o NAME,SIZE,MODEL | grep -v loop

  # Prompt for EFI partition
  while true; do
    read -p "Enter EFI partition (e.g., sda1, nvme0n1p1): " part_boot
    if [ -b "/dev/$part_boot" ]; then
      break
    else
      error "Invalid partition. Try again."
    fi
  done

  # Prompt for root partition
  while true; do
    read -p "Enter root partition (e.g., sda2, nvme0n1p2): " part_root
    if [ -b "/dev/$part_root" ] && [ "/dev/$part_root" != "/dev/$part_boot" ]; then
      break
    else
      error "Invalid or same as EFI partition. Try again."
    fi
  done

  # Prompt for home partition (optional)
  echo "Home partition is optional. Leave blank to skip."
  read -p "Enter home partition (e.g., sda3, nvme0n1p3 or blank): " part_home
  if [ -n "$part_home" ]; then
    if [ -b "/dev/$part_home" ] && [ "/dev/$part_home" != "/dev/$part_boot" ] && [ "/dev/$part_home" != "/dev/$part_root" ]; then
      : # Valid partition
    else
      warn "Invalid home partition or same as EFI or root. Skipping separate home."
      part_home=""
    fi
  else
    part_home=""
  fi

  # Prompt for swap partition (optional)
  echo "Swap partition is optional. Leave blank to skip."
  read -p "Enter swap partition (e.g., sda4, nvme0n1p4, or blank): " part_swap
  if [ -n "$part_swap" ] && [ ! -b "/dev/$part_swap" ]; then
    warn "Invalid swap partition. Skipping swap."
    part_swap=""
  elif [ -n "$part_swap" ] && { [ "/dev/$part_swap" = "/dev/$part_boot" ] || [ "/dev/$part_swap" = "/dev/$part_root" ] || [ "/dev/$part_swap" = "/dev/$part_home" ]; }; then
    warn "Swap cannot be same as EFI, root, or home. Skipping swap."
    part_swap=""
  fi
fi

clear

# Choose filesystem type
info "Choose a filesystem for root partition:"
echo "1) ext4"
echo "2) btrfs"
while true; do
  read -p "Enter choice (1 or 2): " fs_choice
  case $fs_choice in
  1)
    filesystem="ext4"
    break
    ;;
  2)
    filesystem="btrfs"
    break
    ;;
  *) error "Invalid choice. Enter 1 or 2." ;;
  esac
done

# Configure LUKS encryption for root
info "Enable LUKS encryption for root partition?"
echo "1) Yes"
echo "2) No"
while true; do
  read -p "Enter choice (1 or 2): " luks_choice
  case $luks_choice in
  1)
    luks_enabled="yes"
    break
    ;;
  2)
    luks_enabled="no"
    break
    ;;
  *) error "Invalid choice. Enter 1 or 2." ;;
  esac
done

# LUKS password for root (if enabled)
if [ "$luks_enabled" = "yes" ]; then
  info "Set LUKS encryption password for root:"
  while true; do
    read -s -p "Enter LUKS password: " luks_password
    echo
    read -s -p "Confirm LUKS password: " luks_password_confirm
    echo
    if [ "$luks_password" = "$luks_password_confirm" ]; then
      if [ -z "$luks_password" ]; then
        error "LUKS password cannot be empty. Try again."
      else
        break
      fi
    else
      error "Passwords do not match. Try again."
    fi
  done
fi

# Set up LUKS for root partition if enabled
if [ "$luks_enabled" = "yes" ]; then
  info "Setting up LUKS encryption for root..."

  # Check if partition is already a LUKS container
  if cryptsetup isLuks "/dev/$part_root" 2>/dev/null; then
    warn "Partition /dev/$part_root already contains a LUKS header. It will be overwritten."
  fi

  # Format and open LUKS container
  echo -n "$luks_password" | cryptsetup luksFormat "/dev/$part_root" - || {
    error "Failed to encrypt root partition. Aborting."
    exit 1
  }
  echo -n "$luks_password" | cryptsetup luksOpen "/dev/$part_root" luks-root - || {
    error "Failed to open encrypted root partition. Aborting."
    exit 1
  }
  root_device="/dev/mapper/luks-root"
else
  root_device="/dev/$part_root"
fi

# Set up home partition (manual partitioning only)
if [ "$partitioning" = "manual" ] && [ -n "$part_home" ]; then
  info "Setting up home partition..."
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
        error "Incorrect password. Try again."
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
        info "Enable LUKS encryption for home partition?"
        echo "1) Yes"
        echo "2) No"
        while true; do
          read -p "Enter choice (1 or 2): " home_luks_choice
          case $home_luks_choice in
          1)
            home_luks_enabled="yes"
            break
            ;;
          2)
            home_luks_enabled="no"
            break
            ;;
          *) error "Invalid choice. Enter 1 or 2." ;;
          esac
        done

        if [ "$home_luks_enabled" = "yes" ]; then
          info "Setting up LUKS for home partition..."

          if [ "$luks_enabled" = "yes" ]; then
            echo "Do you want to use the same password as the root partition?"
            echo "1) Yes"
            echo "2) No"
            while true; do
              read -p "Enter choice (1 or 2): " same_password_choice
              case $same_password_choice in
              1)
                home_luks_password="$luks_password"
                break
                ;;
              2) break ;;
              *) error "Invalid choice. Enter 1 or 2." ;;
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
                  error "Password cannot be empty. Try again."
                else
                  break
                fi
              else
                error "Passwords do not match. Try again."
              fi
            done
          fi

          echo -n "$home_luks_password" | cryptsetup luksFormat "$home_device" - || {
            error "Failed to encrypt home partition."
            exit 1
          }
          echo -n "$home_luks_password" | cryptsetup luksOpen "$home_device" luks-home - || {
            error "Failed to open encrypted home partition."
            exit 1
          }
          home_mapped_device="/dev/mapper/luks-home"
          home_encrypted="yes"
        else
          home_mapped_device="$home_device"
        fi

        echo "Formatting home partition with $filesystem"
        if [ "$filesystem" = "ext4" ]; then
          mkfs.ext4 -F "$home_mapped_device" || {
            error "Failed to format home partition."
            exit 1
          }
        elif [ "$filesystem" = "btrfs" ]; then
          mkfs.btrfs -f "$home_mapped_device" || {
            error "Failed to format home partition."
            exit 1
          }
        fi
      fi
    else
      echo "Home partition has no filesystem."

      info "Enable LUKS encryption for home partition?"
      echo "1) Yes"
      echo "2) No"
      while true; do
        read -p "Enter choice (1 or 2): " home_luks_choice
        case $home_luks_choice in
        1)
          home_luks_enabled="yes"
          break
          ;;
        2)
          home_luks_enabled="no"
          break
          ;;
        *) error "Invalid choice. Enter 1 or 2." ;;
        esac
      done

      if [ "$home_luks_enabled" = "yes" ]; then
        info "Setting up LUKS for home partition..."

        if [ "$luks_enabled" = "yes" ]; then
          echo "Do you want to use the same password as the root partition?"
          echo "1) Yes"
          echo "2) No"
          while true; do
            read -p "Enter choice (1 or 2): " same_password_choice
            case $same_password_choice in
            1)
              home_luks_password="$luks_password"
              break
              ;;
            2) break ;;
            *) error "Invalid choice. Enter 1 or 2." ;;
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
                error "Password cannot be empty. Try again."
              else
                break
              fi
            else
              error "Passwords do not match. Try again."
            fi
          done
        fi

        echo -n "$home_luks_password" | cryptsetup luksFormat "$home_device" - || {
          error "Failed to encrypt home partition."
          exit 1
        }
        echo -n "$home_luks_password" | cryptsetup luksOpen "$home_device" luks-home - || {
          error "Failed to open encrypted home partition."
          exit 1
        }
        home_mapped_device="/dev/mapper/luks-home"
        home_encrypted="yes"
      else
        home_mapped_device="$home_device"
      fi

      echo "Formatting home partition with $filesystem"
      if [ "$filesystem" = "ext4" ]; then
        mkfs.ext4 -F "$home_mapped_device" || {
          error "Failed to format home partition."
          exit 1
        }
      elif [ "$filesystem" = "btrfs" ]; then
        mkfs.btrfs -f "$home_mapped_device" || {
          error "Failed to format home partition."
          exit 1
        }
      fi
    fi
  fi
fi

# Format partitions
info "Formatting partitions..."

echo "Formatting EFI partition..."
mkfs.fat -F32 "/dev/$part_boot" || {
  error "Failed to format EFI partition."
  exit 1
}

echo "Formatting root partition with $filesystem..."
if [ "$filesystem" = "ext4" ]; then
  mkfs.ext4 -F "$root_device" || {
    error "Failed to format root partition."
    exit 1
  }
elif [ "$filesystem" = "btrfs" ]; then
  mkfs.btrfs -f "$root_device" || {
    error "Failed to format root partition."
    exit 1
  }
fi

if [ -n "$part_swap" ]; then
  echo "Setting up swap partition..."
  mkswap "/dev/$part_swap" || {
    warn "Failed to format swap partition. Continuing without swap."
    part_swap=""
  }
fi

# Mount filesystems
info "Mounting filesystems..."

echo "Mounting root partition..."
mount "$root_device" /mnt || {
  error "Failed to mount root partition."
  exit 1
}

echo "Creating and mounting boot partition..."
mkdir -p /mnt/boot
mount "/dev/$part_boot" /mnt/boot || {
  error "Failed to mount boot partition."
  exit 1
}

if [ -n "$home_mapped_device" ]; then
  echo "Creating and mounting home partition..."
  mkdir -p /mnt/home
  mount "$home_mapped_device" /mnt/home || {
    warn "Failed to mount home partition. Continuing without separate home."
    home_mapped_device=""
  }
fi

if [ -n "$part_swap" ]; then
  echo "Activating swap..."
  swapon "/dev/$part_swap" || {
    warn "Failed to activate swap. Continuing without swap."
  }
fi

echo "All filesystems mounted successfully."

# Generate hardware configuration
info "Generating hardware configuration..."
nixos-generate-config --root /mnt --show-hardware-config >"./hosts/$selected_host/hardware-configuration.nix" || {
  error "Failed to generate hardware configuration."
  exit 1
}
echo "Hardware configuration generated."

# Update username in variables.nix
sed -i -e "s/username = \".*\"/username = \"$username\"/" "./hosts/$selected_host/variables.nix"
git add * 2>/dev/null || true

# Copy flake to /etc/nixos
mkdir -p /mnt/etc/nixos
cp -r ./ /mnt/etc/nixos || {
  error "Failed to copy configuration to /mnt/etc/nixos."
  exit 1
}

clear

# Run nixos-install
info "Installing system..."
nixos-install --flake "/mnt/etc/nixos#$selected_host" --no-root-passwd || exit 1

# Set the user password
echo -e "\n${BLUE}Setting password for $username...${NC}"
nixos-enter --root /mnt -c "echo '$password' | passwd --stdin $username" || {
  warn "Failed to set user password. You'll need to set it after booting."
}

# Create user directories
info "Creating user directories..."
mkdir -p "/mnt/home/$username"/{Downloads,Documents,Pictures,Videos,.local/bin}

# Copy flake to ~/NixOS
info "Copying flake to /home/$username/NixOS..."
mkdir -p "/mnt/home/$username/NixOS"
cp -r ./ "/mnt/home/$username/NixOS/" || {
  warn "Failed to copy configuration to user's home directory."
}

# Set proper ownership of user directories
uid=$(awk -F: -v user="$username" '$1 == user {print $3}' /mnt/etc/passwd)
gid=$(awk -F: -v user="$username" '$1 == user {print $4}' /mnt/etc/passwd)

if [ -z "$uid" ] || [ "$uid" -eq 0 ]; then
  uid="$username"
fi
if [ -z "$gid" ] || [ "$gid" -eq 0 ]; then
  gid="users"
fi

chown -R "$uid:$gid" "/mnt/home/$username" || {
  warn "Failed to set ownership of user directories."
}

# All done!
info "Installation complete!"
info "Please reboot your system for the changes to take effect."
