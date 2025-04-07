#!/usr/bin/env bash

case $1 in
drun)
  # rofi_theme="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/launchers/type-4/style-7.rasi"
  # rofi_theme="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/launchers/type-4/style-3.rasi"
  rofi_theme="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/launchers/type-2/style-2.rasi"
  r_override="entry{placeholder:'Search Applications...';}listview{lines:9;}"

  pkill rofi || rofi -show drun -theme-str "$r_override" -theme "$rofi_theme"
  ;;
window)
  rofi_theme="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/launchers/type-2/style-2.rasi"
  r_override="entry{placeholder:'Search Windows...';}listview{lines:9;}"

  pkill rofi || rofi -show window -theme-str "$r_override" -theme "$rofi_theme"
  ;;
file)
  rofi_theme="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/launchers/type-2/style-2.rasi"
  r_override="entry{placeholder:'Search Files...';}listview{lines:8;}"

  pkill rofi || rofi -show filebrowser -theme-str "$r_override" -theme "$rofi_theme"
  ;;
emoji)
  r_override="entry{placeholder:'Search Emojis...';}listview{lines:15;}"
  rofi_theme="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/launchers/type-4/style-4.rasi"

  pkill rofi || rofi -modi emoji -show emoji -theme "${rofi_theme}" -theme-str "$r_override"
  ;;
games)
  r_override="entry{placeholder:'Search Games...';}listview{lines:15;}"
  rofi_theme="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/launchers/type-1/style-5.rasi"

  pkill rofi || rofi -show games -modi games -theme "${rofi_theme}" -theme-str "$r_override"
  ;;
help | --help)
  echo "Usage: launch.sh [ACTION]"
  echo "Launch various rofi modes with custom themes and settings."
  echo ""
  echo "Actions:"
  echo "  drun         Launch application search mode"
  echo "  window       Switch between open windows"
  echo "  file         Browse and search files"
  echo "  emoji        Search and insert emojis"
  echo "  games        Launch games menu"
  echo "  help         Display this help message"
  echo "  --help       Same as 'help'"
  echo ""
  echo "If no action is specified, defaults to 'drun' mode."
  exit 0
  ;;
*) exec "$0" drun ;;
esac
