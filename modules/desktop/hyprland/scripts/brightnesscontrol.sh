#!/usr/bin/env sh

ScrDir=`dirname "$(realpath "$0")"`

function print_error
{
cat << "EOF"
    ./brightnesscontrol.sh <action>
    ...valid actions are...
        i -- <i>ncrease brightness [+5%]
        d -- <d>ecrease brightness [-5%]
EOF
}

function send_notification {
    brightness=`brightnessctl info | grep -oP "(?<=\()\d+(?=%)" | cat`
    brightinfo=$(brightnessctl info | awk -F "'" '/Device/ {print $2}')
    angle="$(((($brightness + 2) / 5) * 5))"
    ico="$HOME/.config/hypr/icons/notifications/vol/vol-${angle}.svg"
    bar=$(seq -s "." $(($brightness / 15)) | sed 's/[0-9]//g')
    notify-send -a "System" -r 91190 -t 800 -i "${ico}" "${brightness}${bar}" "${brightinfo}"
    # dunstify "t2" -i $ico -a "$brightness$bar" "$brightinfo" -r 91190 -t 800
}

function get_brightness {
    brightnessctl -m | grep -o '[0-9]\+%' | head -c-2
}

case $1 in
i)  # increase the backlight by 5%
    brightnessctl set +5%
    send_notification ;;
d)  # decrease the backlight by 5%
    if [[ $(get_brightness) -lt 5 ]] ; then
        # avoid 0% brightness
        brightnessctl set 1%
    else
        # decrease the backlight by 5%
        brightnessctl set 5%-
    fi
    send_notification ;;
*)  # print error
    print_error ;;
esac

