#!/usr/bin/env bash
## /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##

# Not my own work. This was added through Github PR. Credit to original author

#----- Optimized bars animation without much CPU usage increase --------
bar="▁▂▃▄▅▆▇█"
dict="s/;//g"

# Calculate the length of the bar outside the loop
bar_length=${#bar}

# Create dictionary to replace char with bar
for ((i = 0; i < bar_length; i++)); do
    dict+=";s/$i/${bar:$i:1}/g"
done

# Create cava config
config_file="/tmp/bar_cava_config"
cat >"$config_file" <<EOF
[general]
bars = 10
;framerate = 60
;sensitivity = 120

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF
# ascii_max_range = 9

# Kill cava if it's already running
pkill -f "cava -p $config_file"

# create a cava process for each monitor
for monitor in $(hyprctl monitors | grep "ID" | awk '{print $2}'); do
		cava -p "$config_file" | sed -u "$dict"
done
