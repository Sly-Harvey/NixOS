#!/usr/bin/env bash
set -euo pipefail

# Portable monitor configuration script
# This script only runs if it detects the specific monitors it's designed for

echo "=== Portable Monitor Configuration ==="

# Function to get current monitor configuration fingerprint
get_monitor_fingerprint() {
  local fingerprint=""
  local count_1080=0
  local count_4k=0
  local has_rotated=false

  while IFS= read -r line; do
    if [[ $line =~ ^([A-Za-z0-9-]+)\ connected\ ([0-9]+x[0-9]+) ]]; then
      resolution="${BASH_REMATCH[2]}"

      case "$resolution" in
      "1920x1080")
        ((count_1080++))
        ;;
      "3840x2160")
        ((count_4k++))
        ;;
      esac

      # Check for rotation in the line
      if [[ $line =~ left|right|inverted ]]; then
        has_rotated=true
      fi
    fi
  done < <(xrandr --query)

  fingerprint="${count_1080}x1080p_${count_4k}x4K"
  if [[ "$has_rotated" == true ]]; then
    fingerprint="${fingerprint}_rotated"
  fi

  echo "$fingerprint"
}

# Function to check if this is the target system
is_target_system() {
  local current_fingerprint
  current_fingerprint=$(get_monitor_fingerprint)

  echo "Detected monitor configuration: $current_fingerprint"

  # This script is designed for: 2x 1080p monitors + 1x 4K monitor with rotation
  if [[ "$current_fingerprint" == "2x1080p_1x4K_rotated" ]]; then
    return 0
  else
    return 1
  fi
}

# Function to identify monitors on the target system
identify_target_monitors() {
  local mon_left="" mon_mid="" mon_right=""

  echo "Debug: Analyzing xrandr output..." >&2

  # Get xrandr output first
  local xrandr_output
  xrandr_output=$(xrandr --query)

  echo "Debug: Got xrandr output" >&2

  # Process each line - assign based on current output names since positions will change
  while IFS= read -r line; do
    echo "Debug: Processing line: $line" >&2
    if [[ $line =~ ^([A-Za-z0-9-]+)\ connected ]]; then
      output_name="${BASH_REMATCH[1]}"

      echo "Debug: Found connected output: '$output_name'" >&2

      # Based on your target configuration:
      # MON_LEFT should be HDMI-0 (BenQ EW277HDR)
      # MON_MID should be DP-0 (BenQ EL2870U - 4K)
      # MON_RIGHT should be HDMI-1 (BenQ XL2420T - will be rotated)

      case "$output_name" in
      "DP-0")
        mon_mid="$output_name"
        echo "Debug: Assigned $output_name as mid monitor (4K)" >&2
        ;;
      "HDMI-0")
        mon_left="$output_name"
        echo "Debug: Assigned $output_name as left monitor" >&2
        ;;
      "HDMI-1")
        mon_right="$output_name"
        echo "Debug: Assigned $output_name as right monitor (will be rotated)" >&2
        ;;
      esac
    fi
  done <<<"$xrandr_output"

  echo "Debug: Final assignments - Left: '$mon_left', Mid: '$mon_mid', Right: '$mon_right'" >&2

  if [[ -n "$mon_left" && -n "$mon_mid" && -n "$mon_right" ]]; then
    echo "$mon_left $mon_mid $mon_right"
    return 0
  else
    echo "Debug: Missing assignments - cannot proceed" >&2
    return 1
  fi
}

# Main execution logic
if is_target_system; then
  echo "✓ Detected target monitor configuration - proceeding with setup"

  # Get monitor assignments
  echo "Debug: Calling identify_target_monitors..."
  monitor_assignments=$(identify_target_monitors)
  exit_code=$?

  echo "Debug: identify_target_monitors returned: '$monitor_assignments' (exit code: $exit_code)"

  if [[ $exit_code -eq 0 && -n "$monitor_assignments" ]]; then
    read -r MON_LEFT MON_MID MON_RIGHT <<<"$monitor_assignments"

    echo "Identified monitors:"
    echo "  Left: $MON_LEFT (1920x1080)"
    echo "  Mid: $MON_MID (3840x2160 - 4K)"
    echo "  Right: $MON_RIGHT (1920x1080 - rotated)"

    # Apply the specific xrandr configuration
    echo "Applying monitor configuration..."
    xrandr \
      --output "$MON_LEFT" --mode 1920x1080 --scale 1x1 --pos 0x0 \
      --output "$MON_MID" --mode 3840x2160 --scale 0.5x0.5 --pos 1920x0 --primary \
      --output "$MON_RIGHT" --mode 1920x1080 --scale 1x1 --pos 3840x-420 --rotate left

    echo "✓ Monitor setup complete!"
  else
    echo "✗ Could not identify all required monitors on target system"
    echo "Debug: Exit code was $exit_code, monitor_assignments was '$monitor_assignments'"
    exit 1
  fi
else
  echo "ℹ This system does not match the target monitor configuration."
  echo "ℹ Script designed for: 2x 1080p + 1x 4K monitors with rotation"
  echo "ℹ Skipping monitor configuration."

  # Optionally, you could provide a generic fallback or do nothing
  echo "ℹ If you want to use this script, modify it for your monitor setup."
  exit 0 # Exit gracefully, don't break other people's setups
fi
