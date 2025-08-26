#!/usr/bin/env bash
# set -euo pipefail

# Helper: get output name by monitor serial
# get_output_by_serial() {
#     local serial="$1"
#     for output in $(xrandr --listmonitors | awk '{print $4}'); do
#         edid_path=$(grep -l "$output" /sys/class/drm/*/status 2>/dev/null | sed 's/status$/edid/')
#         if [[ -f "$edid_path" ]]; then
#             current_serial=$(edid-decode "$edid_path" | grep "Serial number:" | awk '{print $3}')
#             if [[ "$current_serial" == "$serial" ]]; then
#                 echo "$output"
#                 return 0
#             fi
#         fi
#     done
#     return 1
# }
get_output_by_serial() {
  local serial="$1"
  local output=""
  # loop through all connected outputs
  for out in $(xrandr --query | awk '/ connected/{print $1}'); do
    # grab EDID and decode
    edid=$(xrandr --prop --verbose | awk -v mon="$out" '
            $1 == mon {flag=1}
            flag && /EDID:/ {getline; edid=$0; while (getline && $0 ~ /^[[:space:]]/) {edid=edid $1} print edid; exit}
        ')
    if [[ -n "$edid" ]]; then
      current_serial=$(echo "$edid" | edid-decode - | awk -F': ' '/Serial number:/ {print $2; exit}')
      if [[ "$current_serial" == "$serial" ]]; then
        echo "$out"
        return 0
      fi
    fi
  done
  return 1
}

# Example mapping
MON_LEFT=$(get_output_by_serial "99J01861SL0")  # BenQ EW277HDR
MON_MID=$(get_output_by_serial "PCK00489SL0")   # BenQ EL2870U
MON_RIGHT=$(get_output_by_serial "99D06760SL0") # BenQ xl2420t

xrandr \
  --output "$MON_LEFT"  --mode 1920x1080 --scale 1x1     --pos 0x0 --primary \
  --output "$MON_MID"   --mode 3840x2160 --scale 0.5x0.5 --pos 1920x0 \
  --output "$MON_RIGHT" --mode 1920x1080 --rotate left   --scale 1x1 --pos 3840x-420

# Apply layout
# xrandr \
#   --output "HDMI-0"  --mode 1920x1080 --scale 1x1     --pos 0x0 --primary \
#   --output "DP-0"   --mode 3840x2160 --scale 0.5x0.5 --pos 1920x0 \
#   --output "HDMI-1" --mode 1920x1080 --rotate left   --scale 1x1 --pos 3840x-420

# Native 4k
# xrandr \
#   --output "HDMI-0" --mode 1920x1080 --scale 1x1 --pos 0x540 --primary \
#   --output "DP-0" --mode 3840x2160 --scale 1x1 --pos 1920x0 \
#   --output "HDMI-1" --mode 1920x1080 --rotate left --scale 1x1 --pos 5760x100
