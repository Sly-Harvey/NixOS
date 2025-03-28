#!/usr/bin/env bash

exec &> /dev/null # Disable all output below this line

r_override="entry{placeholder:'Search Games...';}"
RofiConf="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/launchers/type-1/style-5.rasi"

pkill rofi || rofi -show games -modi games -theme "${RofiConf}" -theme-str "$r_override"
