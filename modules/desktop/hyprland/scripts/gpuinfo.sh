#!/usr/bin/env bash

# Check for NVIDIA GPU using nvidia-smi
nvidia_gpu=$(nvidia-smi --query-gpu=gpu_name --format=csv,noheader,nounits 2>/dev/null | head -n 1)

# Function to define emoji based on temperature
get_temperature_emoji() {
  local temperature="$1"
  if [ "$temperature" -lt 80 ] 2>/dev/null; then
    echo "❄️" # Ice emoji for less than 80°C
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
  local temperature="" utilization="" core_clock="" power_usage=""
  
  # Method 1: Try amd-smi with JSON output
  if command -v amd-smi >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
    local amd_output=$(amd-smi metric -t --json 2>/dev/null)
    if [ -n "$amd_output" ]; then
      temperature=$(echo "$amd_output" | jq -r '.gpu_0.temperature.hotspot_temp // .gpu_0.temperature.edge_temp // (to_entries[] | select(.key | startswith("gpu_")) | .value.temperature.hotspot_temp // .value.temperature.edge_temp) // empty' 2>/dev/null | head -n1)
      utilization=$(echo "$amd_output" | jq -r '.gpu_0.utilization.gfx_activity // (to_entries[] | select(.key | startswith("gpu_")) | .value.utilization.gfx_activity) // empty' 2>/dev/null | head -n1)
      core_clock=$(echo "$amd_output" | jq -r '.gpu_0.clock.gfx_clock // (to_entries[] | select(.key | startswith("gpu_")) | .value.clock.gfx_clock) // empty' 2>/dev/null | head -n1)
      power_usage=$(echo "$amd_output" | jq -r '.gpu_0.power.socket_power // .gpu_0.power.total_power // (to_entries[] | select(.key | startswith("gpu_")) | .value.power.socket_power // .value.power.total_power) // empty' 2>/dev/null | head -n1)
    fi
  fi
  
  # Method 2: Try sensors command
  if [ -z "$temperature" ] && command -v sensors >/dev/null 2>&1; then
    local sensors_output=$(sensors 2>/dev/null | grep -A5 "amdgpu")
    if [ -n "$sensors_output" ]; then
      temperature=$(echo "$sensors_output" | grep -E "(edge|junction|hotspot)" | head -n1 | grep -o '+[0-9]\+' | sed 's/+//')
    fi
  fi
  
  # Method 3: Try hwmon/sysfs fallback
  if [ -z "$temperature" ]; then
    for hwmon in /sys/class/hwmon/hwmon*/; do
      if [ -f "${hwmon}name" ] && [[ "$(cat "${hwmon}name" 2>/dev/null)" == "amdgpu" ]]; then
        for temp_file in "${hwmon}temp1_input" "${hwmon}temp2_input"; do
          if [ -f "$temp_file" ]; then
            local temp_raw=$(cat "$temp_file" 2>/dev/null)
            if [ -n "$temp_raw" ] && [ "$temp_raw" -gt 0 ]; then
              temperature=$((temp_raw / 1000))
              break 2
            fi
          fi
        done
      fi
    done
  fi
  
  # Get additional metrics from sysfs if we have temperature
  if [ -n "$temperature" ] && [ "$temperature" != "N/A" ]; then
    for card in /sys/class/drm/card*/device; do
      if [ -L "$card/driver" ] && basename "$(readlink -f "$card/driver")" 2>/dev/null | grep -qi "amdgpu"; then
        [ -z "$utilization" ] && [ -f "${card}/gpu_busy_percent" ] && utilization=$(cat "${card}/gpu_busy_percent" 2>/dev/null)
        [ -z "$core_clock" ] && [ -f "${card}/pp_dpm_sclk" ] && core_clock=$(cat "${card}/pp_dpm_sclk" 2>/dev/null | grep '\*' | grep -o '[0-9]\+' | head -n1)
        break
      fi
    done
  fi
  
  # Clean up values
  temperature=$(echo "$temperature" | cut -d'.' -f1 2>/dev/null)
  temperature=${temperature:-"N/A"}
  utilization=${utilization:-"N/A"}
  core_clock=${core_clock:-"N/A"}
  power_usage=${power_usage:-"N/A"}

  # Output as JSON
  echo "{\"GPU Temperature\": \"$temperature\", \"GPU Load\": \"$utilization\", \"GPU Core Clock\": \"$core_clock\", \"GPU Power Usage\": \"$power_usage\"}"
}

# Check if primary GPU is NVIDIA
if [ -n "$nvidia_gpu" ]; then
  if [[ $nvidia_gpu == *"NVIDIA-SMI has failed"* ]]; then
    echo "{\"text\":\"N/A\", \"tooltip\":\"Primary GPU: Not found\"}"
    exit 0
  fi

  gpu_info=$(nvidia-smi --query-gpu=temperature.gpu,utilization.gpu,clocks.current.graphics,clocks.max.graphics,power.draw,power.limit --format=csv,noheader,nounits 2>/dev/null)
  IFS=',' read -ra gpu_data <<<"$gpu_info"
  temperature="${gpu_data[0]// /}"
  utilization="${gpu_data[1]// /}"
  current_clock_speed="${gpu_data[2]// /}"
  max_clock_speed="${gpu_data[3]// /}"
  power_usage="${gpu_data[4]// /}"
  power_limit="${gpu_data[5]// /}"
  emoji=$(get_temperature_emoji "$temperature")

  echo "{\"text\":\"$temperature°C\", \"tooltip\":\"Primary GPU: NVIDIA GPU\n$emoji Temperature: $temperature°C\n󰾆 Utilization: $utilization%\n Clock Speed: $current_clock_speed/$max_clock_speed MHz\n Power Usage: $power_usage/$power_limit W\"}"
  exit 0
fi

# Check for AMD GPU
amd_found=false
for card in /sys/class/drm/card*/device; do
  if [ -L "$card/driver" ] && basename "$(readlink -f "$card/driver")" 2>/dev/null | grep -qi "amdgpu"; then
    primary_gpu="AMD GPU"
    amd_output=$(get_amd_gpu_metrics)

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
