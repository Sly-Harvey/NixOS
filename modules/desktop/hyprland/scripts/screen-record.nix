{ pkgs, ... }:
pkgs.writeShellScriptBin "screen-record" ''
  XDG_VIDEOS_DIR="''${XDG_VIDEOS_DIR:-$HOME/Videos}"
  DIR="''${XDG_VIDEOS_DIR}/screen-record"

  mkdir -p "$DIR"

  print_error() {
    cat <<EOF
  Usage: $(basename "$0") <action>
  Valid actions:
    a  : Select area
    m  : Select monitor
  EOF
    exit 1
  }

  timestamp=$(date +"%Y%m%d_%Hh%Mm%Ss")

  if ${pkgs.procps}/bin/pidof wf-recorder > /dev/null; then
    ${pkgs.procps}/bin/pkill wf-recorder
    ${pkgs.libnotify}/bin/notify-send -e -t 2500 -u low "Recording Finished" \
      "Saved to $DIR/recording_''${timestamp}.mp4"
    exit 0
  fi

  case "$1" in
    a) REGION=$(${pkgs.slurp}/bin/slurp) ;;
    m) REGION=$(${pkgs.slurp}/bin/slurp -o) ;;
    *) print_error ;;
  esac

  ${pkgs.wf-recorder}/bin/wf-recorder --audio -g "$REGION && $(${pkgs.libnotify}/bin/notify-send -e -t 2500 -u low "Recording Started")" -f "$DIR/recording_''${timestamp}.mp4"
''
