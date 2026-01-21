{ pkgs, ... }:
pkgs.writeShellScriptBin "batterynotify" ''
  trap resume_processes SIGINT
  in_range() { local num=$1 local min=$2 local max=$3 ;  [[ $num =~ ^[0-9]+$ ]] && (( num >= min && num <= max )); }
  mnc=5 mxc=80 mnl=20 mxl=50 mnu=80  mxu=100 mnt=60 mxt=1000 mnf=80 mxf=100 mnn=1 mxn=60 mni=1 mxi=10 verbose=false undock=false

  while (( "$#" )); do
    case "$1" in
  "--full"|"-f") if in_range "$2" $mnf $mxf; then battery_full_threshold=$2 ; shift 2 ; else echo "$1 Error: Full Threshold must be $mnf - $mxf." >&2 ; exit 1 ; fi;;
  "--critical"|"-c") if in_range "$2" $mnc $mxc; then battery_critical_threshold=$2 ; shift 2 ; else echo "$1 ERROR: Critical Threshold must be $mnc - $mxc." >&2 ; exit 1 ; fi;;
  "--low"|"-l") if in_range "$2" $mnl $mnu; then battery_low_threshold=$2 ; shift 2 ; else echo "$1 ERROR: Low Threshold $mnl - $mnu." >&2 ; exit 1 ; fi;;
  "--unplug"|"-u") if in_range "$2" $mnu $mxu; then unplug_charger_threshold=$2 ; shift 2 ; else echo "$1 ERROR: Unplug Threshold must be $mnu $mxu." >&2 ; exit 1 ; fi;;
  "--timer"|"-t") if in_range "$2" $mnt $mxt; then timer=$2 ; shift 2 ; else echo "$1 ERROR: Timer must be $mnt - $mxt." >&2 ; exit 1 ; fi;;
  "--notify"|"-n") if in_range "$2" $mnn $mxn; then notify=$2 ; shift 2 ; else echo "$1 ERROR: Notify must be $mnn - $mxn in minutes." >&2 ; exit 1 ; fi;;
  "--interval"|"-i") if in_range "$2" $mni $mxi; then interval=$2 ; shift 2 ; else echo "$1 ERROR: Interval must be by $mni% - $mxi% intervals." >&2 ; exit 1 ; fi;;
  "--verbose"|"-v") verbose=true ; shift ;;
  "--undock"|"on") undock=true ; shift ;;
  "--execute"|"-e") execute=$2 ; shift 2 ;;
      *|"--help"|"-h")
        echo "Usage: $0 [options]"
        echo "  --verbose, -v     Verbose Mode"
        echo "  --undock, on     Shows Battery Plug In/Out/Full Notification"
        echo "  --full, -f        Set battery full threshold (default: 100% percent)"
        echo "  --critical, -c    Set battery critical threshold (default: 10% percent)"
        echo "  --low, -l         Set battery low threshold (default: 20% percent)"
        echo "  --unplug, -u      Set unplug charger threshold (default: 80% percent )"
        echo "  --timer, -t       Set countdown timer (default: 120 seconds)"
        echo "  --interval, -i    Set notify interval  on LOW UNPLUG Status  (default: 5% percent)"
        echo "  --notify, -n      Set notify interval for Battery Full Status  (default: 1140 mins/ 1 day)"
        echo "  --execute, -e     Set command/script to execute if battery on critical threshold (default: systemctl suspend)"
        exit 0
        ;;
    esac
  done

  is_laptop() {
    if ${pkgs.gnugrep}/bin/grep -q "Battery" /sys/class/power_supply/BAT*/type; then
      return 0
    else
      echo "Cannot Detect a Battery."
      exit 0
    fi
  }

  fn_notify () {
    ${pkgs.libnotify}/bin/notify-send -a "Power" $1 -u $2 "$3" "$4" -p
  }

  fn_percentage () {
    if [[ "$battery_percentage" -ge "$unplug_charger_threshold" ]] && [[ "$battery_status" != "Discharging" ]] && [[ "$battery_status" != "Full" ]] && (( (battery_percentage - last_notified_percentage) >= $interval )); then
      fn_notify "-t 5000 " "CRITICAL" "Battery Charged" "Battery is at $battery_percentage%. You can unplug the charger!"
      last_notified_percentage=$battery_percentage
    elif [[ "$battery_percentage" -le "$battery_critical_threshold" ]]; then
      count=$(( timer > $mnt ? timer : $mnt ))
      while [ $count -gt 0 ] && [[ $battery_status == "Discharging"* ]]; do
        for battery in /sys/class/power_supply/BAT*; do battery_status=$(<"$battery/status") ; done
        if [[ $battery_status != "Discharging" ]] ; then break ; fi
        fn_notify "-t 5000 -r 69 " "CRITICAL" "Battery Critically Low" "$battery_percentage% is critically low. Device will execute $execute in $((count/60)):$((count%60)) ."
        count=$((count-1))
        sleep 1
      done
      [ $count -eq 0 ] && fn_action
    elif [[ "$battery_percentage" -le "$battery_low_threshold" ]] && [[ "$battery_status" == "Discharging" ]] && (( (last_notified_percentage - battery_percentage) >= $interval )); then
      fn_notify "-t 5000 " "CRITICAL" "Battery Low" "Battery is at $battery_percentage%. Connect the charger."
      last_notified_percentage=$battery_percentage
    fi
  }

  fn_action () {
    count=$(( timer > $mnt ? timer : $mnt ))
    nohup $execute
  }

  fn_status () {
    if [[ $battery_percentage -ge $battery_full_threshold ]] && [ "$battery_status" == *"Charging"* ]; then
      battery_status="Full"
    fi
    case "$battery_status" in
      "Discharging")
        if [[ "$prev_status" != "Discharging" ]] || [[ "$prev_status" == "Full" ]] ; then
          prev_status=$battery_status
          urgency=$([[ $battery_percentage -le "$battery_low_threshold" ]] && echo "CRITICAL" || echo "NORMAL")
          fn_notify "-t 5000 -r 54321 " "$urgency" "Charger Plug OUT" "Battery is at $battery_percentage%."
        fi
        fn_percentage
        ;;
      "Not"*|"Charging")
        if [[ "$prev_status" == "Discharging" ]] || [[ "$prev_status" == "Not"* ]] ; then
          prev_status=$battery_status
          count=$(( timer > $mnt ? timer : $mnt ))
          urgency=$([[ "$battery_percentage" -ge $unplug_charger_threshold ]] && echo "CRITICAL" || echo "NORMAL")
          fn_notify "-t 5000 -r 54321 " "$urgency" "Charger Plug In" "Battery is at $battery_percentage%."
        fi
        fn_percentage
        ;;
      "Full")
        if [[ $battery_status != "Discharging" ]]; then
          now=$(date +%s)
          if [[ "$prev_status" == *"harging"* ]] || ((now - lt >= $((notify*60)) )); then
            fn_notify "-t 5000 -r 54321" "CRITICAL" "Battery Full" "Please unplug your Charger"
            prev_status=$battery_status lt=$now
          fi
        fi
        ;;
      *)
        fn_percentage
        ;;
    esac
  }

  fn_status_change () {
    for battery in /sys/class/power_supply/BAT*; do
      battery_status=$(<"$battery/status")
      battery_percentage=$(<"$battery/capacity")
      if [ "$battery_status" != "$last_battery_status" ] || [ "$battery_percentage" != "$last_battery_percentage" ]; then
        last_battery_status=$battery_status
        last_battery_percentage=$battery_percentage
        fn_percentage
        if $undock; then fn_status ; fi
      fi
    done
  }

  resume_processes() {
    for pid in $pids ; do
      if [ $pid -ne $current_pid ] ; then
        kill -CONT $pid
        ${pkgs.libnotify}/bin/notify-send -a "Battery Notify" -t 2000 -r 9889 -u "CRITICAL" "Debugging ENDED, Resuming Regular Process"
      fi
    done
  }

  main() {
    if is_laptop; then
      rm -fr /tmp/hyprdots.batterynotify*
      battery_full_threshold=''${battery_full_threshold:-100}
      battery_critical_threshold=''${battery_critical_threshold:-10}
      unplug_charger_threshold=''${unplug_charger_threshold:-80}
      battery_low_threshold=''${battery_low_threshold:-20}
      timer=''${timer:-120}
      notify=''${notify:-1140}
      interval=''${interval:-5}
      execute=''${execute:-"systemctl suspend"}

      fn_status_change
      last_notified_percentage=$battery_percentage
      prev_status=$battery_status

      ${pkgs.dbus}/bin/dbus-monitor --system "type='signal',interface='org.freedesktop.DBus.Properties',path='$(${pkgs.upower}/bin/upower -e | ${pkgs.gnugrep}/bin/grep battery)'" 2> /dev/null | while read -r battery_status_change; do
        fn_status_change
      done
    fi
  }

  main
''
