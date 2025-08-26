#!/usr/bin/env bash

WALLPAPER=~/.config/i3/wallpaper.jxl
for output in $(xrandr --listmonitors | awk 'NR>1 {print $4}'); do
    feh --bg-fill "$WALLPAPER" --no-fehbg --output "$output"
done
