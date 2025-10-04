{ pkgs, ... }:
pkgs.writeShellScriptBin "rollback" ''
  # Colors for output
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  NC='\033[0m' # No Color

  success() {
    echo -e "''${GREEN}╔═══════════════════════════════════════════════════════════════════════╗''${NC}"
    echo -e "''${GREEN}║                                                                       ║''${NC}"
    echo -e "''${GREEN}║                      NixOS Rollback Successful!                       ║''${NC}"
    echo -e "''${GREEN}║                                                                       ║''${NC}"
    echo -e "''${GREEN}║       Please reboot your system for the changes to take effect.       ║''${NC}"
    echo -e "''${GREEN}║                                                                       ║''${NC}"
    echo -e "''${GREEN}╚═══════════════════════════════════════════════════════════════════════╝''${NC}"
  }

  info() {
    echo -e "\n''${GREEN}$1''${NC}"
  }

  warn() {
    echo -e "''${YELLOW}$1''${NC}"
  }

  error() {
    echo -e "''${RED}Error: $1''${NC}" >&2
  }

  generation="$1"

  if [ -z "$generation" ]; then
    error "Please provide a generation number (Use list-gens)"
    exit 1
  fi

  if [ ! -d "/nix/var/nix/profiles/system-$generation-link" ]; then
    error "Generation '$generation' does not exist"
    exit 1
  fi

  echo -e "''${GREEN}Generation: $generation''${NC}"

  # nh os rollback -t $generation
  sudo /nix/var/nix/profiles/system-$generation-link/bin/switch-to-configuration boot

  if [ $? -eq 0 ]; then
    success
  # else
  #   failed
  fi
''
