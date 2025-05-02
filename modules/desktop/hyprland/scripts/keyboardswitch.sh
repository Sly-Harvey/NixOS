#!/usr/bin/env sh

hyprctl switchxkblayout all next

layMain=$(hyprctl -j devices | jq '.keyboards' | jq '.[] | select (.main == true)' | awk -F '"' '{if ($2=="active_keymap") print $4}')

# dunstify "${layMain}" -i $HOME/.config/hypr/icons/keyboard.svg -a "Keyboard Layout" -r 91190 -t 800
notify-send -a "System" -r 91190 -t 800 -i "$HOME/.config/hypr/icons/keyboard.svg" "${layMain}"

