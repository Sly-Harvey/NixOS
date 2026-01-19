{ pkgs, defaultWallpaper, ... }:
pkgs.writeShellScriptBin "wallpaper" ''

# Restore
swww restore &> /dev/null

# If there is no wallpaper then set the default
if ! swww query | grep -q "image:" &> /dev/null; then
  swww img "${../../../themes/wallpapers/${defaultWallpaper}}" --transition-step 255 --transition-duration 1 --transition-fps 60 --transition-type none
fi
''
