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
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

success() {
  echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║                                                                       ║${NC}"
  echo -e "${GREEN}║                    NixOS Installation Successful!                     ║${NC}"
  echo -e "${GREEN}║                                                                       ║${NC}"
  echo -e "${GREEN}║       Please reboot your system for the changes to take effect.       ║${NC}"
  echo -e "${GREEN}║                                                                       ║${NC}"
  echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
}

info() {
  echo -e "\n${GREEN}$1${NC}"
}

warn() {
  echo -e "${YELLOW}$1${NC}"
}

error() {
  echo -e "${RED}Error: $1${NC}" >&2
}

currentUser=$(logname)

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
  # This uses awk to insert the new host line after the opening brace
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

        # Add host to flake.nix
        add_host_to_flake "$selected_host"

        # Ask if user wants to edit variables.nix
        read -p "Edit variables.nix for the new host? (Y/n): " edit_vars
        if [[ ! "$edit_vars" =~ ^[nN]$ ]]; then
          # Find available editor
          for editor in "${EDITOR}" nano vim vi; do
            if command -v "$editor" &>/dev/null; then
              $editor "./hosts/$selected_host/variables.nix"
              break
            fi
          done
        fi
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

# replace username variable in variables.nix with $USER
sudo sed -i -e "s/username = \".*\"/username = \"$currentUser\"/" "./hosts/$selected_host/variables.nix"

# Generate Hardware Configuration
info "Generating hardware configuration..."
if [ -f "/etc/nixos/hardware-configuration.nix" ]; then
  sudo cp "/etc/nixos/hardware-configuration.nix" "./hosts/$selected_host/hardware-configuration.nix"
else
  sudo nixos-generate-config --show-hardware-config | sudo tee "./hosts/$selected_host/hardware-configuration.nix" >/dev/null
fi

sudo git -C . add "hosts/$selected_host/*" 2>/dev/null || true
sudo git -C . add "flake.nix" 2>/dev/null || true

# Build the new configuration
info "Building NixOS configuration for host: $selected_host"
sudo nixos-rebuild boot --flake ".#$selected_host"

if [ $? -eq 0 ]; then
  success
# else
#   failed
fi
