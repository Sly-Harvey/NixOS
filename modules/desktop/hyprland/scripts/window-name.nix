{ pkgs, ... }:
pkgs.writeShellScriptBin "window-name" ''
  window_class=$(hyprctl activewindow | ${pkgs.gnugrep}/bin/grep class | ${pkgs.gawk}/bin/awk '{print $2}')
  case $window_class in
    "kitty") echo "kitty " ;;
    "firefox") echo "firefox " ;;
    *) echo "$window_class" ;;
  esac
''
