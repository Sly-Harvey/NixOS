{ pkgs, ... }:
pkgs.writeShellScriptBin "screenshot" ''
  swpy_dir="''${XDG_CONFIG_HOME:-$HOME/.config}/swappy"
  XDG_PICTURES_DIR="''${XDG_PICTURES_DIR:-$HOME/Pictures}"
  save_dir="''${XDG_PICTURES_DIR}/Screenshots"

  mkdir -p "$save_dir"
  mkdir -p "$swpy_dir"

  print_error() {
    cat << EOF
  Usage: $(basename "$0") <action>
  Valid actions:
    p  : Print all screens
    s  : Snip area
    sf : Snip area (frozen)
    m  : Print focused monitor
  EOF
    exit 1
  }

  take_screenshot() {
    local save_file="$(date +'%y%m%d_%Hh%Mm%Ss_screenshot.png')"

    cat > "$swpy_dir/config" << EOF
  [Default]
  save_dir=$save_dir
  save_filename_format=$save_file
  EOF

    case "$1" in
      screen) ${pkgs.stable.grimblast}/bin/grimblast save screen - | ${pkgs.swappy}/bin/swappy -f - ;;
      area)   ${pkgs.stable.grimblast}/bin/grimblast save area - | ${pkgs.swappy}/bin/swappy -f - ;;
      freeze) ${pkgs.stable.grimblast}/bin/grimblast --freeze save area - | ${pkgs.swappy}/bin/swappy -f - ;;
      output) ${pkgs.stable.grimblast}/bin/grimblast save output - | ${pkgs.swappy}/bin/swappy -f - ;;
    esac

    if [ -f "''${save_dir}/''${save_file}" ]; then
      ${pkgs.libnotify}/bin/notify-send -a Screenshot \
                  -i "''${save_dir}/''${save_file}" \
                  "Screenshot Saved" \
                  "$(basename "$save_file")"
    fi
  }

  case "$1" in
    p)  take_screenshot screen ;;
    s)  take_screenshot area ;;
    sf) take_screenshot freeze ;;
    m)  take_screenshot output ;;
    *)  print_error ;;
  esac
''
