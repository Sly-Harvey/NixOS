{ pkgs, defaultWallpaper, ... }:
let
  awww = "${pkgs.awww}/bin/awww";
  awww-daemon = "${pkgs.awww}/bin/awww-daemon";
in
pkgs.writeShellScriptBin "wallpaper" ''

if ! pgrep awww-daemon &> /dev/null; then
  ${awww-daemon} &
  sleep 0.5
fi

# Restore
${awww} restore &> /dev/null

# If there is no wallpaper then set the default
if ! ${awww} query | grep -q "image:" &> /dev/null; then
  ${awww} img "${../../../themes/wallpapers/${defaultWallpaper}}" --transition-step 255 --transition-duration 1 --transition-fps 60 --transition-type none
fi
''
