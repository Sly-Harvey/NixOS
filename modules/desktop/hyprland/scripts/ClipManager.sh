#!/usr/bin/env bash
# Clipboard Manager. This script uses cliphist, rofi, and wl-copy.

# Actions:
# CTRL Del to delete an entry
# ALT Del to wipe clipboard contents

rofi_theme="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/launchers/type-1/style-6.rasi"
r_override="entry{placeholder:'Search Clipboard...';}listview{lines:9;}"

while true; do
  result=$(
    rofi -dmenu -i \
      -kb-custom-1 "Control-Delete" \
      -kb-custom-2 "Alt-Delete" \
      -theme-str "$r_override" \
      -theme "$rofi_theme" < <(cliphist list)
  )

  case "$?" in
  1)
    exit
    ;;
  0)
    case "$result" in
    "")
      continue
      ;;
    *)
      cliphist decode <<<"$result" | wl-copy
      exit
      ;;
    esac
    ;;
  10)
    cliphist delete <<<"$result"
    ;;
  11)
    cliphist wipe
    ;;
  esac
done
