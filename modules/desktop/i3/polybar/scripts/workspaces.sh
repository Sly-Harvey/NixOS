#!/usr/bin/env bash

WORKSPACES=(1 2 3 4 5 6 7 8 9 10)
EXISTING=$(i3-msg -t get_workspaces | jq -r '.[] | .num')
FOCUSED=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).num')
echo -n " " # Add spacing before first workspace
for ws in "${WORKSPACES[@]}"; do
  if [ "$ws" -eq "$FOCUSED" ]; then
    echo -n "%{F#cba6f7}$ws%{F-} "
  # elif echo "$EXISTING" | grep -q "$ws"; then
  #   echo -n "%{F#89b4fa}$ws%{F-} "
  else
    echo -n "%{F#6c7086}$ws%{F-} "
  fi
done
