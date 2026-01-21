{ pkgs, ... }:
pkgs.writeShellScriptBin "mediactrl" ''
  music_icon="''${XDG_CONFIG_HOME:-$HOME/.config}/hypr/icons/music.png"

  play_next() {
    ${pkgs.playerctl}/bin/playerctl next
    show_music_notification
  }

  play_previous() {
    ${pkgs.playerctl}/bin/playerctl previous
    show_music_notification
  }

  toggle_play_pause() {
    ${pkgs.playerctl}/bin/playerctl play-pause
    show_music_notification
  }

  stop_playback() {
    ${pkgs.playerctl}/bin/playerctl stop
    ${pkgs.libnotify}/bin/notify-send -e -u low -i "$music_icon" "Playback Stopped"
  }

  show_music_notification() {
    status=$(${pkgs.playerctl}/bin/playerctl status)
    if [[ "$status" == "Playing" ]]; then
      song_title=$(${pkgs.playerctl}/bin/playerctl metadata title)
      song_artist=$(${pkgs.playerctl}/bin/playerctl metadata artist)
      ${pkgs.libnotify}/bin/notify-send -e -u low -i "$music_icon" "Now Playing:" "$song_title by $song_artist"
    elif [[ "$status" == "Paused" ]]; then
      ${pkgs.libnotify}/bin/notify-send -e -u low -i "$music_icon" "Playback Paused"
    fi
  }

  case "$1" in
    "next")
      play_next
      ;;
    "previous")
      play_previous
      ;;
    "play-pause")
      toggle_play_pause
      ;;
    "stop")
      stop_playback
      ;;
    *)
      echo "Usage: $0 [next|previous|play-pause|stop]"
      exit 1
      ;;
  esac
''
