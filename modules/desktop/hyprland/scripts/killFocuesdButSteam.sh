#!/usr/bin/env bash
if [[ $(hyprctl activewindow -j | jq -r ".class") == "Steam" ]]; then
    xdotool windowunmap $(xdotool getactivewindow)
else
    if [ -n "$pid" ]; then
        kill -9 "$pid"
    fi
fi
