{ pkgs, ... }:
pkgs.writeShellScriptBin "zoom" ''
  current_zoom=$(hyprctl getoption cursor:zoom_factor -j | ${pkgs.jq}/bin/jq -r '.float')

  zoom_step=1.0
  min_zoom=1.0
  max_zoom=5.0

  case "$1" in
    "in")
      new_zoom=$(echo "$current_zoom + $zoom_step" | ${pkgs.bc}/bin/bc)
      if (( $(echo "$new_zoom > $max_zoom" | ${pkgs.bc}/bin/bc -l) )); then
        new_zoom=$max_zoom
      fi
      ;;
    "out")
      new_zoom=$(echo "$current_zoom - $zoom_step" | ${pkgs.bc}/bin/bc)
      if (( $(echo "$new_zoom < $min_zoom" | ${pkgs.bc}/bin/bc -l) )); then
        new_zoom=$min_zoom
      fi
      ;;
    "reset")
      new_zoom=1.0
      ;;
    *)
      echo "Usage: $0 {in|out|reset}"
      exit 1
      ;;
  esac

  hyprctl keyword cursor:zoom_factor "$new_zoom"
  sleep 0.05
''
