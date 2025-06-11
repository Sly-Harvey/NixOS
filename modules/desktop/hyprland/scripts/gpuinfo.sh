#!/usr/bin/env bash

# Check for NVIDIA GPU using nvidia-smi
nvidia_gpu=$(nvidia-smi --query-gpu=gpu_name --format=csv,noheader,nounits 2>/dev/null | head -n 1)

# Function to define emoji based on temperature
get_temperature_emoji() {
  local temperature="$1"
  if [ "$temperature" -lt 80 ] 2>/dev/null; then
    echo "❄️" # Ice emoji for less than 75°C
  else
    echo "🔥" # Fire emoji for 80°C or higher
  fi
}

# Function to get Intel GPU temperature
get_intel_gpu_temperature() {
  local temperature=""

  # Try multiple methods to get Intel GPU temperature
  # Method 1: Try intel_gpu_top if available
  if command -v intel_gpu_top >/dev/null 2>&1; then
    temperature=$(timeout 2s intel_gpu_top -l 2>/dev/null | grep -i "gpu.*°c" | head -n1 | grep -o '[0-9]\+' | head -n1)
  fi

  # Method 2: Try coretemp sensors (fallback for integrated graphics)
  if [ -z "$temperature" ]; then
    temperature=$(sensors 2>/dev/null | grep -E "(Package id 0|Tctl)" | head -n1 | grep -o '+[0-9]\+' | sed 's/+//' | head -n1)
  fi

  # Method 3: Try hwmon directly for Intel GPU
  if [ -z "$temperature" ]; then
    for hwmon in /sys/class/hwmon/hwmon*/; do
      if [ -f "${hwmon}name" ]; then
        name=$(cat "${hwmon}name" 2>/dev/null)
        if [[ "$name" == *"i915"* ]] || [[ "$name" == *"intel"* ]]; then
          if [ -f "${hwmon}temp1_input" ]; then
            temp_raw=$(cat "${hwmon}temp1_input" 2>/dev/null)
            if [ -n "$temp_raw" ] && [ "$temp_raw" -gt 0 ]; then
              temperature=$((temp_raw / 1000))
              break
            fi
          fi
        fi
      fi
    done
  fi

  echo "$temperature"
}

# Function to get AMD GPU metrics
get_amd_gpu_metrics() {
  local card_path="$1"
  local temperature="" utilization="" core_clock="" power_usage=""
  local hwmon_dir=""

  # Method 1: Look in card hwmon subdirectory
  if [ -d "${card_path}/hwmon" ]; then
    hwmon_dir=$(find "${card_path}/hwmon" -type d -name 'hwmon*' -print -quit 2>/dev/null)
  fi

  # Method 2: Look for hwmon with amdgpu name
  if [ -z "$hwmon_dir" ]; then
    for hwmon in /sys/class/hwmon/hwmon*/; do
      if [ -f "${hwmon}name" ]; then
        name=$(cat "${hwmon}name" 2>/dev/null)
        if [[ "$name" == "amdgpu" ]]; then
          hwmon_dir="$hwmon"
          break
        fi
      fi
    done
  fi

  # Temperature - try multiple temperature inputs
  for temp_file in "${hwmon_dir}/temp1_input" "${hwmon_dir}/temp2_input" "${card_path}/gpu_temp" "${card_path}/temp1_input"; do
    if [ -f "$temp_file" ]; then
      temp_raw=$(cat "$temp_file" 2>/dev/null)
      if [ -n "$temp_raw" ] && [ "$temp_raw" -gt 0 ]; then
        if [ "$temp_raw" -gt 1000 ]; then
          temperature=$((temp_raw / 1000)) # Convert from millidegrees
        else
          temperature="$temp_raw" # Already in degrees
        fi
        break
      fi
    fi
  done

  # Utilization - try multiple possible locations
  for util_file in "${card_path}/gpu_busy_percent" "${card_path}/gpu_usage" "${card_path}/utilization"; do
    if [ -f "$util_file" ]; then
      utilization=$(cat "$util_file" 2>/dev/null)
      if [ -n "$utilization" ]; then
        break
      fi
    fi
  done

  # Core Clock - try multiple approaches
  if [ -f "${card_path}/pp_dpm_sclk" ]; then
    # Look for the line with asterisk (current frequency)
    core_clock=$(cat "${card_path}/pp_dpm_sclk" 2>/dev/null | grep '\*' | grep -o '[0-9]\+Mhz\|[0-9]\+MHz' | head -n1 | grep -o '[0-9]\+')
    # If no asterisk line found, get first frequency
    if [ -z "$core_clock" ]; then
      core_clock=$(cat "${card_path}/pp_dpm_sclk" 2>/dev/null | head -n1 | grep -o '[0-9]\+' | head -n1)
    fi
  elif [ -f "${card_path}/gpu_clock" ]; then
    core_clock=$(cat "${card_path}/gpu_clock" 2>/dev/null)
  fi

  # Power Usage - try multiple power files
  for power_file in "${hwmon_dir}/power1_average" "${hwmon_dir}/power1_input" "${card_path}/power_usage"; do
    if [ -f "$power_file" ]; then
      power_raw=$(cat "$power_file" 2>/dev/null)
      if [ -n "$power_raw" ] && [ "$power_raw" -gt 0 ]; then
        if [ "$power_raw" -gt 1000000 ]; then
          power_usage=$(echo "scale=1; $power_raw / 1000000" | bc 2>/dev/null) # Convert from microwatts
        elif [ "$power_raw" -gt 1000 ]; then
          power_usage=$(echo "scale=1; $power_raw / 1000" | bc 2>/dev/null) # Convert from milliwatts
        else
          power_usage="$power_raw" # Already in watts
        fi
        break
      fi
    fi
  done

  # Set defaults for missing values
  temperature=${temperature:-"N/A"}
  utilization=${utilization:-"N/A"}
  core_clock=${core_clock:-"N/A"}
  power_usage=${power_usage:-"N/A"}

  # Output metrics as JSON for parsing
  if command -v jq >/dev/null 2>&1; then
    jq -n \
      --arg temp "$temperature" \
      --arg util "$utilization" \
      --arg clock "$core_clock" \
      --arg power "$power_usage" \
      '{ "GPU Temperature": $temp, "GPU Load": $util, "GPU Core Clock": $clock, "GPU Power Usage": $power }'
  else
    # Fallback if jq is not available
    echo "{\"GPU Temperature\": \"$temperature\", \"GPU Load\": \"$utilization\", \"GPU Core Clock\": \"$core_clock\", \"GPU Power Usage\": \"$power_usage\"}"
  fi
}

# Check if primary GPU is NVIDIA
if [ -n "$nvidia_gpu" ]; then
  # If nvidia-smi failed, format and exit
  if [[ $nvidia_gpu == *"NVIDIA-SMI has failed"* ]]; then
    echo "{\"text\":\"N/A\", \"tooltip\":\"Primary GPU: Not found\"}"
    exit 0
  fi

  primary_gpu="NVIDIA GPU"
  gpu_info=$(nvidia-smi --query-gpu=temperature.gpu,utilization.gpu,clocks.current.graphics,clocks.max.graphics,power.draw,power.limit --format=csv,noheader,nounits 2>/dev/null)
  # Split the comma-separated values into an array
  IFS=',' read -ra gpu_data <<<"$gpu_info"
  temperature="${gpu_data[0]// /}"
  utilization="${gpu_data[1]// /}"
  current_clock_speed="${gpu_data[2]// /}"
  max_clock_speed="${gpu_data[3]// /}"
  power_usage="${gpu_data[4]// /}"
  power_limit="${gpu_data[5]// /}"
  emoji=$(get_temperature_emoji "$temperature")

  echo "{\"text\":\"$temperature°C\", \"tooltip\":\"Primary GPU: $primary_gpu\n$emoji Temperature: $temperature°C\n󰾆 Utilization: $utilization%\n Clock Speed: $current_clock_speed/$max_clock_speed MHz\n Power Usage: $power_usage/$power_limit W\"}"
  exit 0
fi

# Check for AMD GPU
amd_found=false
for card in /sys/class/drm/card*/device; do
  if [ -L "$card/driver" ] && basename "$(readlink -f "$card/driver")" 2>/dev/null | grep -qi "amdgpu"; then
    primary_gpu="AMD GPU"
    amd_output=$(get_amd_gpu_metrics "$card")

    # Parse the JSON output (with fallback for systems without jq)
    if command -v jq >/dev/null 2>&1; then
      temperature=$(echo "$amd_output" | jq -r '.["GPU Temperature"]' 2>/dev/null)
      gpu_load=$(echo "$amd_output" | jq -r '.["GPU Load"]' 2>/dev/null)
      core_clock=$(echo "$amd_output" | jq -r '.["GPU Core Clock"]' 2>/dev/null)
      power_usage=$(echo "$amd_output" | jq -r '.["GPU Power Usage"]' 2>/dev/null)
    else
      # Simple parsing without jq
      temperature=$(echo "$amd_output" | grep -o '"GPU Temperature": "[^"]*"' | cut -d'"' -f4)
      gpu_load=$(echo "$amd_output" | grep -o '"GPU Load": "[^"]*"' | cut -d'"' -f4)
      core_clock=$(echo "$amd_output" | grep -o '"GPU Core Clock": "[^"]*"' | cut -d'"' -f4)
      power_usage=$(echo "$amd_output" | grep -o '"GPU Power Usage": "[^"]*"' | cut -d'"' -f4)
    fi

    # Check if we got valid temperature data
    if [ "$temperature" != "N/A" ] && [ -n "$temperature" ] && [ "$temperature" != "null" ]; then
      emoji=$(get_temperature_emoji "$temperature")

      # Build tooltip with available information
      tooltip="Primary GPU: $primary_gpu\n$emoji Temperature: $temperature°C"
      [ "$gpu_load" != "N/A" ] && [ "$gpu_load" != "null" ] && tooltip="$tooltip\n󰾆 Utilization: $gpu_load%"
      [ "$core_clock" != "N/A" ] && [ "$core_clock" != "null" ] && tooltip="$tooltip\n Clock Speed: $core_clock MHz"
      [ "$power_usage" != "N/A" ] && [ "$power_usage" != "null" ] && tooltip="$tooltip\n Power Usage: $power_usage W"

      echo "{\"text\":\"$temperature°C\", \"tooltip\":\"$tooltip\"}"
      exit 0
    fi
    amd_found=true
    break
  fi
done

# If AMD GPU was found but no temperature, show limited info
if [ "$amd_found" = true ]; then
  echo "{\"text\":\"N/A\", \"tooltip\":\"Primary GPU: AMD GPU\nTemperature: Not available\"}"
  exit 0
fi

# Check for Intel GPU
intel_gpu=$(lspci -nn 2>/dev/null | grep -i "VGA compatible controller\|3D controller\|Display controller" | grep -i "Intel Corporation")
if [ -n "$intel_gpu" ]; then
  primary_gpu="Intel GPU"
  temperature=$(get_intel_gpu_temperature)

  if [ -n "$temperature" ] && [ "$temperature" != "0" ]; then
    emoji=$(get_temperature_emoji "$temperature")
    echo "{\"text\":\"$temperature°C\", \"tooltip\":\"Primary GPU: $primary_gpu\n$emoji Temperature: $temperature°C\"}"
    exit 0
  else
    echo "{\"text\":\"N/A\", \"tooltip\":\"Primary GPU: $primary_gpu\nTemperature: Not available\"}"
    exit 0
  fi
fi

# If no GPU is found
echo "{\"text\":\"N/A\", \"tooltip\":\"Primary GPU: Not found\"}"
