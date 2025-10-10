#!/usr/bin/env bash

XDG_VIDEOS_DIR="${XDG_VIDEOS_DIR:-$HOME/Videos}"
DIR="${XDG_VIDEOS_DIR}/screen-record"

# Create output dir if it doesn't exist.
mkdir -p $DIR

command -v wf-recorder >/dev/null 2>&1 || {
  echo "wf-recorder not found"
  exit 1
}
command -v slurp >/dev/null 2>&1 || {
  echo "slurp not found"
  exit 1
}
command -v notify-send >/dev/null 2>&1 || {
  echo "notify-send not found"
  exit 1
}

print_error() {
  cat <<EOF
Usage: $(basename "$0") <action>
Valid actions:
  a  : Select area
  m  : Select monitor
EOF
  exit 1
}

# Generate a timestamp
timestamp=$(date +"%Y%m%d_%Hh%Mm%Ss")

if pidof wf-recorder >/dev/null; then
  pkill wf-recorder
  notify-send -e -t 2500 -u low "Recording Finished" \
    "Saved to $DIR/recording_${timestamp}.mp4"
  exit 0
fi

case "$1" in
a) REGION=$(slurp) ;;
m) REGION=$(slurp -o) ;;
*) print_error ;;
esac

# Start recording with wf-recorder and save to a file with the timestamp
wf-recorder --audio -g "$REGION && $(notify-send -e -t 2500 -u low "Recording Started")" -f "$DIR/recording_${timestamp}.mp4"
