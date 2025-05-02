#!/usr/bin/env bash

# Check for NVIDIA GPU using nvidia-smi
nvidia_gpu=$(nvidia-smi --query-gpu=gpu_name --format=csv,noheader,nounits 2>/dev/null | head -n 1)

# Function to define emoji based on temperature
get_temperature_emoji() {
  local temperature="$1"
  if [ "$temperature" -lt 75 ] 2>/dev/null; then
    echo "❄️"  # Ice emoji for less than 75°C
  else
    echo "🔥"  # Fire emoji for 75°C or higher
  fi
}

# Function to get Intel GPU temperature from 'sensors'
get_intel_gpu_temperature() {
  local temperature
  temperature=$(sensors 2>/dev/null | grep "Package id 0" | awk '{print $4}' | sed 's/+//;s/°C//;s/\.0//')
  echo "$temperature"
}

# Function to get AMD GPU metrics dynamically
get_amd_gpu_metrics() {
  local card_path="$1"
  local temperature utilization core_clock power_usage

  # Find hwmon directory dynamically
  hwmon_dir=$(find "${card_path}/hwmon" -type d -name 'hwmon*' -print -quit 2>/dev/null)

  # Temperature (in millidegrees Celsius, divide by 1000)
  if [ -f "${hwmon_dir}/temp1_input" ]; then
    temperature=$(cat "${hwmon_dir}/temp1_input" 2>/dev/null)
    temperature=$((temperature / 1000))  # Convert to °C
  else
    temperature="N/A"
  fi

  # Utilization (in percentage)
  if [ -f "${card_path}/gpu_busy_percent" ]; then
    utilization=$(cat "${card_path}/gpu_busy_percent" 2>/dev/null)
  else
    utilization="N/A"
  fi

  # Core Clock (in MHz, extract current clock from pp_dpm_sclk)
  if [ -f "${card_path}/pp_dpm_sclk" ]; then
    core_clock=$(cat "${card_path}/pp_dpm_sclk" 2>/dev/null | grep -o '[0-9]\+ MHz' | head -n 1 | cut -d' ' -f1)
  else
    core_clock="N/A"
  fi

  # Power Usage (in microwatts, divide by 1,000,000 for watts)
  if [ -f "${hwmon_dir}/power1_average" ]; then
    power_usage=$(cat "${hwmon_dir}/power1_average" 2>/dev/null)
    power_usage=$(echo "scale=2; $power_usage / 1000000" | bc 2>/dev/null)
  else
    power_usage="N/A"
  fi

  # Output metrics as JSON for parsing
  jq -n \
    --arg temp "$temperature" \
    --arg util "$utilization" \
    --arg clock "$core_clock" \
    --arg power "$power_usage" \
    '{ "GPU Temperature": $temp, "GPU Load": $util, "GPU Core Clock": $clock, "GPU Power Usage": $power }'
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
  IFS=',' read -ra gpu_data <<< "$gpu_info"
  temperature="${gpu_data[0]// /}"
  utilization="${gpu_data[1]// /}"
  current_clock_speed="${gpu_data[2]// /}"
  max_clock_speed="${gpu_data[3]// /}"
  power_usage="${gpu_data[4]// /}"
  power_limit="${gpu_data[5]// /}"
  emoji=$(get_temperature_emoji "$temperature")

  echo "{\"text\":\"$temperature°C\", \"tooltip\":\"Primary GPU: $primary_gpu\n$emoji Temperature: $temperature°C\n󰾆 Utilization: $utilization%\n Clock Speed: $current_clock_speed/$max_clock_speed MHz\n Power Usage: $power_usage/$power_limit W\"}"
else
  # Check for AMD GPU dynamically by looking for amdgpu driver
  primary_gpu="AMD GPU"
  amd_card=""
  for card in /sys/class/drm/card*/device; do
    if [ -L "$card/driver" ] && basename "$(readlink -f "$card/driver")" | grep -qi "amdgpu" 2>/dev/null; then
      amd_card="$card"
      break
    fi
  done

  if [ -n "$amd_card" ]; then
    amd_output=$(get_amd_gpu_metrics "$amd_card")
    temperature=$(echo "$amd_output" | jq -r '.["GPU Temperature"]')
    gpu_load=$(echo "$amd_output" | jq -r '.["GPU Load"]')
    core_clock=$(echo "$amd_output" | jq -r '.["GPU Core Clock"]')
    power_usage=$(echo "$amd_output" | jq -r '.["GPU Power Usage"]')

    # Skip if temperature is invalid or missing
    if [ "$temperature" != "N/A" ] && [ -n "$temperature" ]; then
      # Get emoji based on temperature
      emoji=$(get_temperature_emoji "$temperature")
      # Print the formatted information in JSON
      echo "{\"text\":\"$temperature°C\", \"tooltip\":\"Primary GPU: $primary_gpu\n$emoji Temperature: $temperature°C\n󰾆 Utilization: $gpu_load%\n Clock Speed: $core_clock MHz\n Power Usage: $power_usage W\"}"
      exit 0
    fi
  fi

  # Check for Intel GPU
  primary_gpu="Intel GPU"
  intel_gpu=$(lspci -nn 2>/dev/null | grep -i "VGA compatible controller" | grep -i "Intel Corporation" | awk -F' ' '{print $1}')
  if [ -n "$intel_gpu" ]; then
    temperature=$(get_intel_gpu_temperature)
    if [ -n "$temperature" ]; then
      emoji=$(get_temperature_emoji "$temperature")
      # Print the formatted information in JSON
      echo "{\"text\":\"$temperature°C\", \"tooltip\":\"Primary GPU: $primary_gpu\n$emoji Temperature: $temperature°C\"}"
      exit 0
    fi
  fi

  # If no GPU is found
  primary_gpu="Not found"
  echo "{\"text\":\"N/A\", \"tooltip\":\"Primary GPU: $primary_gpu\"}"
fi
