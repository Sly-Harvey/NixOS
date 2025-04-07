#!/usr/bin/env bash

# kill yad to not interfere with this binds
pkill yad || true

# check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
fi

# define the config files
keybinds_conf="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/hyprland.conf"
rofi_theme="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/launchers/type-4/style-4.rasi"
r_override="entry{placeholder:'Search KeyBinds...';}"
msg='☣️ NOTE ☣️: Clicking with Mouse or Pressing ENTER will have NO function'

# combine the contents of the keybinds files and filter for keybinds
keybinds=$(cat "$keybinds_conf" | grep -E '^bind')
# keybinds+=$'\n'"$more_binds"

# check for any keybinds to display
if [[ -z "$keybinds" ]]; then
    echo "no keybinds found."
    exit 1
fi

# replace $mainmod with super in the displayed keybinds for rofi
display_keybinds=$(echo "$keybinds" | sed 's/\$mainMod/SUPER/g')

# use rofi to display the keybinds with the modified content
echo "$display_keybinds" | rofi -dmenu -i -theme-str "$r_override" -config "$rofi_theme" -mesg "$msg"
