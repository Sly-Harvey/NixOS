{
  lib,
  pkgs,
  terminal,
  ...
}:
pkgs.writeShellScriptBin "launcher" ''
  # check if rofi is already running
  if pidof rofi >/dev/null; then
    pkill rofi
    exit 0
  fi

  case $1 in
  drun)
    # rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/launchers/type-4/style-7.rasi"
    # rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/launchers/type-4/style-3.rasi"
    rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/launchers/type-2/style-2.rasi"
    r_override="entry{placeholder:'Search Applications...';}listview{lines:9;}"

    rofi -show drun -theme-str "$r_override" -theme "$rofi_theme"
    ;;
  window)
    # rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/launchers/type-2/style-2.rasi"
    rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/launchers/type-4/style-4.rasi"
    r_override="entry{placeholder:'Search Windows...';}listview{lines:12;}"

    rofi -show window -theme-str "$r_override" -theme "$rofi_theme"
    ;;
  file)
    rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/launchers/type-2/style-2.rasi"
    r_override="entry{placeholder:'Search Files...';}listview{lines:8;}"

    rofi -show filebrowser -theme-str "$r_override" -theme "$rofi_theme"
    ;;
  tmux)
    rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/launchers/type-4/style-4.rasi"
    r_override="entry{placeholder:'Search Tmux Sessions...';}listview{lines:15;}"

    sessions=$(tmux ls -F '#{session_name}: #{session_path} (#{session_windows} windows)' |
      rofi -dmenu -i -theme-str "$r_override" -theme "$rofi_theme" | cut -d: -f1)
    if [[ $sessions ]]; then
      ${terminal} --hold -e tmux attach -t $sessions
    fi
    ;;
  wallpaper)
    rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/launchers/wallpaper-select.rasi"
    r_override="entry{placeholder:'Search Wallpapers...';}"

    CACHE_DIR=$HOME/.cache/wallpaper-previews
    WALLPAPER_DIR="${../themes/wallpapers}"


    rofi_cmd() {
      rofi -dmenu \
        -i \
        -theme-str "$r_override" \
        -theme "$rofi_theme"
    }

    if [ ! -d "''${CACHE_DIR}" ] ; then
      mkdir -p "''${CACHE_DIR}"
    fi

    for wallpaper in "$WALLPAPER_DIR"/*.{webp,jxl,jpg,jpeg,png}; do
      if [ -f "$wallpaper" ]; then
        wallpaper_filename=$(basename "$wallpaper")
        wallpaper_name="''${wallpaper_filename%.*}"
        if [ ! -f "''${CACHE_DIR}/''${wallpaper_name}.jpg" ] ; then
          magick "$wallpaper" -strip -gravity center -thumbnail 320x180^ -extent 320x180 "''${CACHE_DIR}/''${wallpaper_name}.jpg"
        fi
      fi
    done

    CHOICE=$(${lib.getExe pkgs.fd} --type f . "''${WALLPAPER_DIR}" \
      | sed 's/.*\///' \
      | sort \
      | while read -r A ; do echo -en "$A\x00icon\x1f""''${CACHE_DIR}"/"''${A%.*}.jpg\n" ; done \
      | rofi_cmd)
    [ -z "$CHOICE" ] && exit 0

    swww img "$WALLPAPER_DIR/$CHOICE" --transition-step 90 --transition-duration 1 --transition-fps 60 --transition-type wipe
    ;;
  emoji)
    rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/launchers/type-4/style-4.rasi"
    r_override="entry{placeholder:'Search Emojis...';}listview{lines:15;}"

    rofi -modi emoji -show emoji -theme "''${rofi_theme}" -theme-str "$r_override"
    ;;
  games)
    r_override="entry{placeholder:'Search Games...';}listview{lines:15;}"
    rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/launchers/type-1/style-5.rasi"

    rofi -show games -modi games -theme "''${rofi_theme}" -theme-str "$r_override"
    ;;
  help | --help | -h)
    echo "Usage: launcher [ACTION]"
    echo "Launch various rofi modes with custom themes and settings."
    echo ""
    echo "Actions:"
    echo "  drun         Launch application search mode"
    echo "  window       Switch between open windows"
    echo "  file         Browse and search files"
    echo "  tmux         Search active tmux sessions"
    echo "  wallpaper    Search and set wallpapers"
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
''
