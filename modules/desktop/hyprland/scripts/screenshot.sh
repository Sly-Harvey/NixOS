#!/usr/bin/env bash

swpy_dir="${XDG_CONFIG_HOME:-$HOME/.config}/swappy"
XDG_PICTURES_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}"
save_dir="${XDG_PICTURES_DIR}/Screenshots"
save_file="$(date +'%y%m%d_%Hh%Mm%Ss_screenshot.png')"

mkdir -p $save_dir
mkdir -p $swpy_dir
echo -e "[Default]\nsave_dir=$save_dir\nsave_filename_format=$save_file" > $swpy_dir/config

# Ensure required binaries
command -v grimblast >/dev/null 2>&1 || { echo "grimblast not found"; exit 1; }
command -v swappy >/dev/null 2>&1 || { echo "swappy not found"; exit 1; }
command -v notify-send >/dev/null 2>&1 || { echo "notify-send not found"; exit 1; }

print_error() {
    cat << EOF
Usage: $(basename "$0") <action>
Valid actions:
  p  : Print all screens
  s  : Snip current screen
  sf : Snip current screen (frozen)
  m  : Print focused monitor
EOF
    exit 1
}

case "$1" in
    p)  grimblast save screen - | swappy -f - ;;
    s)  grimblast save area - | swappy -f - ;;
    sf) grimblast --freeze save area - | swappy -f - ;;
    m)  grimblast save output - | swappy -f - ;;
    *)  print_error ;;
esac

# Notify if saved
if [ -f "${save_dir}/${save_file}" ]; then
    notify-send -a Screenshot -r 91190 -t 2200 -i "${save_dir}/${save_file}" "Saved in ${save_dir}"
fi
