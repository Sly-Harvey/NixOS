{ pkgs, ... }:

pkgs.writeShellScriptBin "gpuinfo" ''
    set -u

    export PATH="${pkgs.coreutils}/bin:${pkgs.gnugrep}/bin:${pkgs.gawk}/bin:${pkgs.gnused}/bin:${pkgs.pciutils}/bin:${pkgs.jq}/bin:${pkgs.util-linux}/bin:${pkgs.lm_sensors}/bin:${pkgs.findutils}/bin:$PATH"

    state_dir="''${XDG_RUNTIME_DIR:-/run/user/$UID}/gpuinfo"
    state_file="$state_dir/state"
    lock_file="$state_dir/lock"

    mkdir -p "$state_dir"
    chmod 700 "$state_dir" 2>/dev/null || true

    exec 9>"$lock_file"
    flock -w 1 9 || {
      printf '{"text":"GPU …","tooltip":"gpuinfo is already running"}\n'
      exit 0
    }

    tired=0
    for arg in "$@"; do
      case "$arg" in
        --tired) tired=1 ;;
      esac
    done

    timeout_cmd() {
      timeout 2s "$@" 2>/dev/null
    }

    has_gpu() {
      case "$1" in
        nvidia)
          lspci -nn | grep -Ei 'VGA|3D' | grep -iq '10de'
          ;;
        amd)
          lspci -nn | grep -Ei 'VGA|3D' | grep -iq '1002'
          ;;
        intel)
          lspci -nn | grep -Ei 'VGA|3D' | grep -iq '8086'
          ;;
      esac
    }

    available_gpus() {
      gpus=""
      has_gpu nvidia && gpus="$gpus nvidia"
      has_gpu amd && gpus="$gpus amd"
      has_gpu intel && gpus="$gpus intel"
      echo "$gpus" | awk '{$1=$1; print}'
    }

    get_state_value() {
      key="$1"
      grep -E "^$key=" "$state_file" 2>/dev/null | tail -n1 | cut -d= -f2-
    }

    set_state_value() {
      key="$1"
      value="$2"

      tmp="$state_file.tmp.''$$"
      touch "$state_file"

      grep -v -E "^$key=" "$state_file" > "$tmp" 2>/dev/null || true
      printf '%s=%s\n' "$key" "$value" >> "$tmp"
      mv "$tmp" "$state_file"
    }

    json() {
      text="$1"
      tooltip="$2"
      class="''${3:-}"

      jq -cn \
        --arg text "$text" \
        --arg tooltip "$tooltip" \
        --arg class "$class" \
        '{text:$text, tooltip:$tooltip, class:$class}'
    }

    first_available_gpu() {
      available_gpus | awk '{print $1}'
    }

    current_gpu() {
      priority="$(get_state_value priority || true)"

      if [ -n "$priority" ] && has_gpu "$priority"; then
        echo "$priority"
      else
        first="$(first_available_gpu)"
        [ -n "$first" ] && set_state_value priority "$first"
        echo "$first"
      fi
    }

    toggle_gpu() {
      available="$(available_gpus)"
      current="$(current_gpu)"

      if [ -z "$available" ]; then
        json "GPU ?" "No supported GPU found" "error"
        exit 0
      fi

      next=""
      found_current=0

      for gpu in $available; do
        if [ "$found_current" = 1 ]; then
          next="$gpu"
          break
        fi

        if [ "$gpu" = "$current" ]; then
          found_current=1
        fi
      done

      if [ -z "$next" ]; then
        next="$(echo "$available" | awk '{print $1}')"
      fi

      set_state_value priority "$next"
      json "GPU: $next" "Selected GPU: $next"
      exit 0
    }

    reset_state() {
      rm -f "$state_file"
      first="$(first_available_gpu)"
      [ -n "$first" ] && set_state_value priority "$first"
      json "GPU reset" "gpuinfo state reset"
      exit 0
    }

    general_query() {
      sensors_data="$(sensors 2>/dev/null || true)"

      temperature="$(
        printf '%s\n' "$sensors_data" |
          grep -m 1 -E '(edge|Package id.*|junction|hotspot|Tctl)' |
          awk -F ':' '{gsub(/[^0-9.+-]/, "", $2); print int($2)}'
      )"

      utilization="$(
        awk '
          /cpu / {
            idle=$5
            total=0
            for (i=2; i<=NF; i++) total += $i
            if (total > 0) print int((1 - idle / total) * 100)
          }
        ' /proc/stat
      )"

      [ -z "$temperature" ] && temperature="?"
      [ -z "$utilization" ] && utilization="?"

      primary_gpu="System sensors"
    }

    nvidia_query() {
      primary_gpu="NVIDIA GPU"

      if [ "$tired" = "1" ]; then
        nvidia_addr="$(lspci | grep -Ei 'VGA|3D' | grep -i nvidia | awk '{print $1}' | head -n1)"
        if [ -n "$nvidia_addr" ] && [ -r "/sys/bus/pci/devices/0000:$nvidia_addr/power/runtime_status" ]; then
          runtime_status="$(cat "/sys/bus/pci/devices/0000:$nvidia_addr/power/runtime_status" 2>/dev/null || true)"
          if printf '%s' "$runtime_status" | grep -qi 'suspend'; then
            json "󰤂" "NVIDIA GPU is suspended" "suspended"
            exit 0
          fi
        fi
      fi

      if command -v nvidia-smi >/dev/null 2>&1; then
        gpu_info="$(
          timeout_cmd nvidia-smi \
            --query-gpu=name,temperature.gpu,utilization.gpu,clocks.current.graphics,clocks.max.graphics,power.draw,power.limit \
            --format=csv,noheader,nounits |
            head -n1
        )"

        if [ -n "$gpu_info" ]; then
          name="$(printf '%s\n' "$gpu_info" | awk -F, '{gsub(/^ +| +$/, "", $1); print $1}')"
          temperature="$(printf '%s\n' "$gpu_info" | awk -F, '{gsub(/^ +| +$/, "", $2); print $2}')"
          utilization="$(printf '%s\n' "$gpu_info" | awk -F, '{gsub(/^ +| +$/, "", $3); print $3}')"
          current_clock_speed="$(printf '%s\n' "$gpu_info" | awk -F, '{gsub(/^ +| +$/, "", $4); print $4}')"
          max_clock_speed="$(printf '%s\n' "$gpu_info" | awk -F, '{gsub(/^ +| +$/, "", $5); print $5}')"
          power_usage="$(printf '%s\n' "$gpu_info" | awk -F, '{gsub(/^ +| +$/, "", $6); print $6}')"
          power_limit="$(printf '%s\n' "$gpu_info" | awk -F, '{gsub(/^ +| +$/, "", $7); print $7}')"

          primary_gpu="NVIDIA ''${name#NVIDIA }"
          return
        fi
      fi

      general_query
      primary_gpu="NVIDIA GPU / fallback sensors"
    }

    amd_query() {
      primary_gpu="AMD GPU"

      for device in /sys/class/drm/card*/device; do
        [ -L "$device/driver" ] || continue
        driver="$(basename "$(readlink -f "$device/driver")" 2>/dev/null || true)"

        if [ "$driver" = "amdgpu" ]; then
          if [ -f "$device/gpu_busy_percent" ]; then
            utilization="$(cat "$device/gpu_busy_percent" 2>/dev/null || true)"
          fi

          hwmon="$(find "$device/hwmon" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | head -n1 || true)"

          if [ -n "$hwmon" ]; then
            # Prefer edge temperature if labels exist, otherwise use the first readable temp input.
            for label in "$hwmon"/temp*_label; do
              [ -f "$label" ] || continue

              label_value="$(cat "$label" 2>/dev/null || true)"
              case "$label_value" in
                edge|junction|hotspot)
                  input="''${label%_label}_input"
                  if [ -f "$input" ]; then
                    raw="$(cat "$input" 2>/dev/null || true)"
                    if [ -n "$raw" ]; then
                      temperature="$((raw / 1000))"
                      break
                    fi
                  fi
                  ;;
              esac
            done

            if [ -z "''${temperature:-}" ]; then
              for input in "$hwmon"/temp*_input; do
                [ -f "$input" ] || continue
                raw="$(cat "$input" 2>/dev/null || true)"
                if [ -n "$raw" ]; then
                  temperature="$((raw / 1000))"
                  break
                fi
              done
            fi

            for power_input in "$hwmon"/power*_average "$hwmon"/power*_input; do
              [ -f "$power_input" ] || continue
              raw_power="$(cat "$power_input" 2>/dev/null || true)"
              if [ -n "$raw_power" ]; then
                power_usage="$((raw_power / 1000000))"
                break
              fi
            done
          fi

          if [ -f "$device/pp_dpm_sclk" ]; then
            core_clock="$(
              grep '\*' "$device/pp_dpm_sclk" 2>/dev/null |
              grep -o '[0-9]\+' |
              head -n1
            )"
          fi

          break
        fi
      done

      # Fallbacks, but do not overwrite AMD values that were already found.
      if [ -z "''${temperature:-}" ]; then
        sensors_data="$(sensors 2>/dev/null || true)"
        temperature="$(
          printf '%s\n' "$sensors_data" |
          grep -m 1 -E '(edge|junction|hotspot|Tctl)' |
          awk -F ':' '{gsub(/[^0-9.+-]/, "", $2); print int($2)}'
        )"
      fi

      [ -z "''${temperature:-}" ] && temperature="?"
      [ -z "''${utilization:-}" ] && utilization="?"
    }

    intel_query() {
      primary_gpu="Intel GPU"
      general_query
    }

    make_output() {
      temp="''${temperature:-?}"
      util="''${utilization:-?}"

      if [ "$temp" = "?" ]; then
        icon="󰍛"
        class="unknown"
      elif [ "$temp" -ge 85 ] 2>/dev/null; then
        icon=""
        class="critical"
      elif [ "$temp" -ge 70 ] 2>/dev/null; then
        icon=""
        class="warning"
      else
        icon=""
        class="normal"
      fi

      text="$icon ''${temp}°C"

      tooltip="$primary_gpu"
      tooltip="$tooltip
  Temperature: ''${temp}°C"

      if [ -n "''${utilization:-}" ]; then
        tooltip="$tooltip
  Utilization: ''${util}%"
      fi

      if [ -n "''${current_clock_speed:-}" ] && [ -n "''${max_clock_speed:-}" ]; then
        tooltip="$tooltip
  Clock: ''${current_clock_speed}/''${max_clock_speed} MHz"
      elif [ -n "''${core_clock:-}" ]; then
        tooltip="$tooltip
  Clock: ''${core_clock} MHz"
      fi

      if [ -n "''${power_usage:-}" ]; then
        if [ -n "''${power_limit:-}" ]; then
          tooltip="$tooltip
  Power: ''${power_usage}/''${power_limit} W"
        else
          tooltip="$tooltip
  Power: ''${power_usage} W"
        fi
      fi

      json "$text" "$tooltip" "$class"
    }

    case "''${1:-}" in
      --toggle|-t)
        toggle_gpu
        ;;
      --reset|-rf)
        reset_state
        ;;
      --use|-u)
        requested="''${2:-}"
        if [ -z "$requested" ]; then
          json "GPU ?" "Missing GPU name for --use" "error"
          exit 0
        fi

        if has_gpu "$requested"; then
          set_state_value priority "$requested"
          json "GPU: $requested" "Selected GPU: $requested"
        else
          json "GPU ?" "GPU '$requested' was not found" "error"
        fi
        exit 0
        ;;
    esac

    selected="$(current_gpu)"

    case "$selected" in
      nvidia)
        nvidia_query
        ;;
      amd)
        amd_query
        ;;
      intel)
        intel_query
        ;;
      *)
        primary_gpu="No supported GPU detected"
        temperature="?"
        utilization="?"
        ;;
    esac

    make_output
''
