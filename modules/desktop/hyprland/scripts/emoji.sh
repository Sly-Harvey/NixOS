#!/usr/bin/env bash

exec &> /dev/null # Disable all output below this line

r_override="entry{placeholder:'Search Emojis...';}"
RofiConf="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/launchers/type-4/style-4.rasi"

pkill rofi || rofi -modi emoji -show emoji -theme "${RofiConf}" -theme-str "$r_override"
