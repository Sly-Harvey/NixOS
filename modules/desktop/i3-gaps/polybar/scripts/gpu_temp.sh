#!/usr/bin/env bash

if command -v nvidia-smi &>/dev/null; then
  TEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)
  echo "GPU $TEMP°C"
else
  for card in /sys/class/drm/card*; do
    if [ -e "$card/device/hwmon" ]; then
      for hwmon in "$card/device/hwmon/hwmon"*; do
        if [ -e "$hwmon/temp1_input" ]; then
          TEMP=$(cat "$hwmon/temp1_input")
          TEMP=$((TEMP / 1000))
          echo "GPU $TEMP°C"
          exit 0
        fi
      done
    fi
  done
  echo "GPU temperature not found"
fi
