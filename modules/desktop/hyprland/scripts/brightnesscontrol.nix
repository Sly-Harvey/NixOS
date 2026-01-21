{ pkgs, ... }:
pkgs.writeShellScriptBin "brightnesscontrol" ''
  icodir="$HOME/.config/hypr/icons/notifications/vol"

  print_error() {
    cat << "EOF"
    brightnesscontrol <action>
    ...valid actions are...
        i -- <i>ncrease brightness [+5%]
        d -- <d>ecrease brightness [-5%]
EOF
  }

  send_notification() {
    brightness=$(${pkgs.brightnessctl}/bin/brightnessctl info | ${pkgs.gnugrep}/bin/grep -oP "(?<=\()\d+(?=%)" | cat)
    brightinfo=$(${pkgs.brightnessctl}/bin/brightnessctl info | ${pkgs.gawk}/bin/awk -F "'" '/Device/ {print $2}')
    angle="$(((($brightness + 2) / 5) * 5))"
    ico="''${icodir}/vol-''${angle}.svg"
    bar=$(${pkgs.coreutils}/bin/seq -s "." $(($brightness / 15)) | ${pkgs.gnused}/bin/sed 's/[0-9]//g')
    ${pkgs.libnotify}/bin/notify-send -a "System" -r 91190 -t 800 -i "''${ico}" "''${brightness}''${bar}" "''${brightinfo}"
  }

  get_brightness() {
    ${pkgs.brightnessctl}/bin/brightnessctl -m | ${pkgs.gnugrep}/bin/grep -o '[0-9]\+%' | ${pkgs.coreutils}/bin/head -c-2
  }

  case $1 in
  i)
    ${pkgs.brightnessctl}/bin/brightnessctl set +5%
    send_notification ;;
  d)
    if [[ $(get_brightness) -lt 5 ]] ; then
      ${pkgs.brightnessctl}/bin/brightnessctl set 1%
    else
      ${pkgs.brightnessctl}/bin/brightnessctl set 5%-
    fi
    send_notification ;;
  *)
    print_error ;;
  esac
''
