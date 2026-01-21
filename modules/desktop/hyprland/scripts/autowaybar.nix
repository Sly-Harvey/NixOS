{ pkgs, ... }:
pkgs.writeShellScriptBin "autowaybar" ''
  UID_VAL=$(${pkgs.coreutils}/bin/id -u)

  check_workspace_empty() {
    active_workspace=$(hyprctl activeworkspace -j | ${pkgs.jq}/bin/jq '.id')
    clients=$(hyprctl clients -j | ${pkgs.jq}/bin/jq "[.[] | select(.workspace.id == $active_workspace)]")
    [ "$(echo "$clients" | ${pkgs.jq}/bin/jq 'length')" -eq 0 ]
  }

  show_waybar() {
    if ! ${pkgs.procps}/bin/pgrep "waybar" > /dev/null; then
      ${pkgs.waybar}/bin/waybar &
    fi
  }

  hide_waybar() {
    ${pkgs.procps}/bin/pkill waybar
  }

  toggle_waybar() {
    if check_workspace_empty; then
      hide_waybar
    else
      show_waybar
    fi
  }

  toggle_waybar

  ${pkgs.socat}/bin/socat -U - UNIX-CONNECT:/run/user/$UID_VAL/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r event; do
    case "$event" in
      workspace* | openwindow* | closewindow* | activewindow*)
        toggle_waybar
        ;;
    esac
  done
''
