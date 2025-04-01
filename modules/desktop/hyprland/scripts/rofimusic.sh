#!/usr/bin/env bash

# Directory for icons
iDIR="$HOME/.config/hypr/icons"

# My playlists
# Added _s for easy searching
declare -A no_shuffle=(
  ["_Limo 🎵"]="https://youtube.com/playlist?list=PLLosUj2DlL27b3e4j6k84Bae4uDj7Jgpy"
  ["_Classics 🎵"]="https://youtube.com/playlist?list=PLLosUj2DlL25PeM3YDfOqjrNRb6qhGruh"
  ["_80s 90s 2000s 🎵"]="https://youtube.com/playlist?list=PLLosUj2DlL26gkV6hzGrmlSiLA1EzBmnI"
  ["_Carriageway 🎵"]="https://youtube.com/playlist?list=PLLosUj2DlL248qtltzreF9fTmQsQY4iYV"
  ["_Motorway 🎵"]="https://youtube.com/playlist?list=PLLosUj2DlL25AAqr1jHInZNlZgHhk2gAl"
  ["_Metal 🎵"]="https://youtube.com/playlist?list=PLLosUj2DlL25HL6fVPEdR_HBKmmnj4V7k"
  ["_Hard Rock 🎵"]="https://youtube.com/playlist?list=PLLosUj2DlL24P-FtCGNXOsYMYSw9kYpXn"
  ["_Rock 🎵"]="https://youtube.com/playlist?list=PLLosUj2DlL24GsFtEVBPieGAWn5FfEDB3"
)

declare -A shuffle=(
  ["Pop 📻🎶"]="https://youtube.com/playlist?list=PLMC9KNkIncKtPzgY-5rmhvj7fax8fdxoj"
  # ["Classics UK 🎻🎶"]="https://stream3.hippynet.co.uk:8008/stream.mp3"
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
)

# Combine into menu_options array
declare -A menu_options
for key in "${!no_shuffle[@]}"; do menu_options["$key"]="${no_shuffle[$key]}"; done
for key in "${!shuffle[@]}"; do menu_options["$key"]="${shuffle[$key]}"; done

# Function for displaying notifications
notification() {
  notify-send -e -t 2500 -u normal -i "$iDIR/music.png" "Playing now: $1"
}

# Main function
main() {
  r_override="entry{placeholder:'Search Music...';}listview{lines:10;}"
  choice=$(printf "%s\n" "${!menu_options[@]}" | rofi -dmenu -theme-str "$r_override" -theme ~/.config/rofi/launchers/type-2/style-2.rasi -i -p "")

  if [ -z "$choice" ]; then
    exit 1
  fi

  link="${menu_options[$choice]}"

  notification "$choice"

  # Check if the link is a playlist and handle shuffling
  if [[ $link == *playlist* ]]; then
    if [[ -v no_shuffle["$choice"] ]]; then
      mpv --vid=no "$link"
    else
      mpv --vid=no --shuffle "$link"
    fi
  else
    # Non-playlist links (e.g., radio streams) play without shuffle
    mpv "$link"
  fi
}

# Check if an online music process is running and send a notification, otherwise run the main function
pkill mpv && notify-send -e -t 2500 -u low -i "$iDIR/music.png" "Playback stopped" || main
