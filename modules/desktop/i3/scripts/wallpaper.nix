{ pkgs, ... }:
pkgs.writeShellScriptBin "wallpaper" ''
for output in $(xrandr --listmonitors | awk 'NR>1 {print $4}'); do
    feh --bg-fill "$1" --no-fehbg --output "$output"
done
''
