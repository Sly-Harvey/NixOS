#!/usr/bin/env bash
# Directory for icons
iDIR="$HOME/.config/hypr/icons"

declare -A no_shuffle=(
)

declare -A shuffle=(
  ["Pop 📻🎶"]="https://youtube.com/playlist?list=PLMC9KNkIncKtPzgY-5rmhvj7fax8fdxoj"
  ["Dance 📻🎶"]="https://dancewave.online:443/dance.mp3"
  ["Lofi Radio ☕️🎶"]="https://play.streamafrica.net/lofiradio"
  ["96.3 Easy Rock 📻🎶"]="https://radio-stations-philippines.com/easy-rock"
  ["Rock 📻🎶"]="https://www.youtube.com/playlist?list=PL6Lt9p1lIRZ311J9ZHuzkR5A3xesae2pk"
  ["Ghibli Music 🎻🎶"]="https://youtube.com/playlist?list=PLNi74S754EXbrzw-IzVhpeAaMISNrzfUy&si=rqnXCZU5xoFhxfOl"
  ["Top Youtube Music 2023 ☕️🎶"]="https://youtube.com/playlist?list=PLDIoUOhQQPlXr63I_vwF9GD8sAKh77dWU&si=y7qNeEVFNgA-XxKy"
  ["Chillhop ☕️🎶"]="https://stream.zeno.fm/fyn8eh3h5f8uv"
  ["SmoothChill ☕️🎶"]="https://media-ssl.musicradio.com/SmoothChill"
  ["Smooth UK ☕️🎶"]="https://icecast.thisisdax.com/SmoothUKMP3"
  ["Relaxing Music ☕️🎶"]="https://youtube.com/playlist?list=PLMIbmfP_9vb8BCxRoraJpoo4q1yMFg4CE"
  ["Youtube Remix 📻🎶"]="https://youtube.com/playlist?list=PLeqTkIUlrZXlSNn3tcXAa-zbo95j0iN-0"

  # My youtube playlists
  # Added _s for easy searching
  ["_Headbangers 🎵"]="https://youtube.com/playlist?list=PLLosUj2DlL27g7BfUwAEoBr2Cr5EY0aP8"
  ["_Motorway 🎵"]="https://youtube.com/playlist?list=PLLosUj2DlL2613eXf-20WT6VQnZenrg0X"
  ["_Carriageway 🎵"]="https://youtube.com/playlist?list=PLLosUj2DlL26qNYOBo0_9yW9za1Egwp_y"
  ["_Classics 🎵"]="https://youtube.com/playlist?list=PLLosUj2DlL260MDLEfAej9CqFqdycTf3X"
  ["_Metal 🎵"]="https://youtube.com/playlist?list=PLLosUj2DlL246iFzN3q8-cYCA43YBxv_z"
  ["_Limo 🎵"]="https://youtube.com/playlist?list=PLLosUj2DlL27x3iZrv2ElvTK7-iQzQKYY"
  ["_80s 90s 2000s 🎵"]="https://youtube.com/playlist?list=PLLosUj2DlL24FAtYVcivVfHImRsu-ocj4"
  ["_Hard Rock 🎵"]="https://youtube.com/playlist?list=PLLosUj2DlL25A5u32lnZXtc_AUy-u2AUd"
  # ["_Dance 🎵"]="https://youtube.com/playlist?list=PLLosUj2DlL27pJt4jO3HUkItoqtE8XaP9"
)

# Combine into menu_options array
declare -A menu_options
for key in "${!no_shuffle[@]}"; do menu_options["$key"]="${no_shuffle[$key]}"; done
for key in "${!shuffle[@]}"; do menu_options["$key"]="${shuffle[$key]}"; done

MPV_SOCKET="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/mpv-socket"

notification() {
  # Default icon
  local icon="$iDIR/music.png"

  # Option 1: Try to get album art (if ytdl-hook plugin is enabled in mpv)
  # if [ -S "$MPV_SOCKET" ] && [[ "$2" == *"playlist"* ]]; then
  #   thumbnail_url=$(echo '{"command": ["get_property", "metadata/by-key/thumbnail"]}' | socat - "$MPV_SOCKET" 2>/dev/null | jq -r '.data // empty')
  #   if [ -n "$thumbnail_url" ] && [ "$thumbnail_url" != "null" ]; then
  #     # Download thumbnail to temp file and use it
  #     temp_thumb="${XDG_RUNTIME_DIR:-/tmp}/mpv_thumb.jpg"
  #     curl -s "$thumbnail_url" -o "$temp_thumb"
  #     icon="$temp_thumb"
  #   fi
  # fi

  # Option 2: Use genre-based icons (uncomment and create these icons)
  # if [[ "$1" == *"Rock"* ]]; then
  #   icon="$iDIR/rock.png"
  # elif [[ "$1" == *"Pop"* ]]; then
  #   icon="$iDIR/pop.png"
  # elif [[ "$1" == *"Lofi"* ]]; then
  #   icon="$iDIR/lofi.png"
  # fi

  notify-send -e -t 2500 -u normal -i "$icon" "$1" "$2"
}

stop_mpv() {
  if pgrep -x "mpv" >/dev/null; then
    if [ -S "$MPV_SOCKET" ]; then
      echo '{"command": ["quit"]}' | socat - "$MPV_SOCKET" >/dev/null 2>&1
    else
      pkill mpv
    fi
    notification "Playback stopped" ""
    return 0
  fi
  return 1
}

main() {
  # TODO: increase this value if adding more playlists
  r_override="entry{placeholder:'Search Music...';}listview{lines:10;}"
  choice=$(printf "%s\n" "${!menu_options[@]}" | rofi -dmenu -theme-str "$r_override" -theme ~/.config/rofi/launchers/type-2/style-2.rasi -i -p "")

  if [ -z "$choice" ]; then
    exit 1
  fi

  link="${menu_options[$choice]}"
  # notification "Playing" "$choice"

  # Remove socket if it exists
  [ -S "$MPV_SOCKET" ] && rm -f "$MPV_SOCKET"

  # Set up script for monitoring
  monitor_script="${XDG_RUNTIME_DIR:-/tmp}/mpv_monitor_$$"
  cat >"$monitor_script" <<'EOF'
#!/usr/bin/env bash
MPV_SOCKET="$1"
CHOICE="$2"
IDIR="$3"
LAST_TITLE=""
SKIP_FIRST=true

# Wait for socket to be created
while [ ! -S "$MPV_SOCKET" ] && pgrep -x "mpv" > /dev/null; do
  sleep 0.5
done

# Function for notifications inside the monitor
monitor_notification() {
  notify-send -e -t 2500 -u normal -i "$IDIR/music.png" "$1" "$2"
}

while [ -S "$MPV_SOCKET" ] && pgrep -x "mpv" > /dev/null; do
  CURRENT_TITLE=$(echo '{"command": ["get_property", "media-title"]}' | socat - "$MPV_SOCKET" 2>/dev/null | jq -r '.data // empty')
  
  if [ -n "$CURRENT_TITLE" ] && [ "$CURRENT_TITLE" != "null" ]; then
    if [ "$SKIP_FIRST" = true ]; then
      SKIP_FIRST=false
      LAST_TITLE="$CURRENT_TITLE"
    elif [ "$CURRENT_TITLE" != "$LAST_TITLE" ]; then
      monitor_notification "Now Playing" "$CURRENT_TITLE"
      LAST_TITLE="$CURRENT_TITLE"
    fi
  fi
  
  sleep 1
done

# Clean up
rm -f "$0"
EOF

  chmod +x "$monitor_script"

  # Kill any other instances of the monitor
  pkill -f "bash.*mpv_monitor_" 2>/dev/null

  # Start MPV with the selected option
  if [[ $link == *playlist* ]]; then
    if [[ -v no_shuffle["$choice"] ]]; then
      mpv --vid=no --input-ipc-server="$MPV_SOCKET" "$link" &
    else
      mpv --vid=no --shuffle --input-ipc-server="$MPV_SOCKET" "$link" &
    fi
  else
    mpv --vid=no --input-ipc-server="$MPV_SOCKET" "$link" &
  fi

  # Start monitoring in background with a delay to avoid race conditions
  sleep 1
  "$monitor_script" "$MPV_SOCKET" "$choice" "$iDIR" &
}

# Check if an online music process is running and stop it, otherwise run the main function
stop_mpv || main
