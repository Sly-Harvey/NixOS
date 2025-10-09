{ pkgs, defaultWallpaper, ... }:
pkgs.writeShellScriptBin "wallpaper" ''

# Restore
swww restore &> /dev/null

# If there is no wallpaper then set the default
if ! swww query | grep -q "image:" &> /dev/null; then
  swww img "${../../../themes/wallpapers/${defaultWallpaper}}"
fi
''
