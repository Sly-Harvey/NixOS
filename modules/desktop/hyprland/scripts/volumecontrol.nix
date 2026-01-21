{ pkgs, ... }:
pkgs.writeShellScriptBin "volumecontrol" ''
  icodir="$HOME/.config/hypr/icons/notifications/vol"

  print_error() {
    cat << "EOF"
    volumecontrol -[device] <action>
    ...valid device are...
        i -- [i]nput device
        o -- [o]utput device
    ...valid actions are...
        i -- <i>ncrease volume [+5]
        d -- <d>ecrease volume [-5]
        m -- <m>ute [x]
EOF
  }

  notify_vol() {
    vol=$(${pkgs.pamixer}/bin/pamixer $srce --get-volume | cat)
    angle=$((((vol + 2) / 5) * 5))
    ico="''${icodir}/vol-''${angle}.svg"
    bar=$(${pkgs.coreutils}/bin/seq -s "." $((vol / 15)) | ${pkgs.gnused}/bin/sed 's/[0-9]//g')
    ${pkgs.libnotify}/bin/notify-send -a "System" -r 91190 -t 800 -i "''${ico}" "''${vol}''${bar}" "$nsink"
  }

  notify_mute() {
    mute=$(${pkgs.pamixer}/bin/pamixer $srce --get-mute | cat)
    if [ "$mute" == "true" ] ; then
      ${pkgs.libnotify}/bin/notify-send -a "System" -r 61190 -t 800 -i "''${icodir}/muted-''${dvce}.svg" "Muted" "$nsink"
    else
      ${pkgs.libnotify}/bin/notify-send -a "System" -r 61190 -t 800 -i "''${icodir}/unmuted-''${dvce}.svg" "Unmuted" "$nsink"
    fi
  }

  while getopts io SetSrc
  do
    case $SetSrc in
    i) nsink=$(${pkgs.pamixer}/bin/pamixer --list-sources | ${pkgs.gnugrep}/bin/grep "_input." | ${pkgs.coreutils}/bin/head -1 | ${pkgs.gawk}/bin/awk -F '" "' '{print $NF}' | ${pkgs.gnused}/bin/sed 's/"//')
        srce="--default-source"
        dvce="mic" ;;
    o) nsink=$(${pkgs.pamixer}/bin/pamixer --get-default-sink | ${pkgs.gnugrep}/bin/grep "_output." | ${pkgs.gawk}/bin/awk -F '" "' '{print $NF}' | ${pkgs.gnused}/bin/sed 's/"//')
        srce=""
        dvce="speaker" ;;
    esac
  done

  if [ $OPTIND -eq 1 ] ; then
    print_error
  fi

  shift $((OPTIND -1))
  step="''${2:-1}"

  case $1 in
    i) ${pkgs.pamixer}/bin/pamixer $srce -i ''${step}
        notify_vol ;;
    d) ${pkgs.pamixer}/bin/pamixer $srce -d ''${step}
        notify_vol ;;
    m) ${pkgs.pamixer}/bin/pamixer $srce -t
        notify_mute ;;
    *) print_error ;;
  esac
''
