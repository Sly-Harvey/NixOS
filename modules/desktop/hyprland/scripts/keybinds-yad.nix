{ pkgs, ... }:
let
  flakePath = "$HOME/ZyNixOS/flake.nix";
in
pkgs.writeShellScriptBin "keybinds-yad" ''
  if ${pkgs.procps}/bin/pidof rofi >/dev/null; then
    ${pkgs.procps}/bin/pkill rofi
  fi

  if ${pkgs.procps}/bin/pidof yad >/dev/null; then
    ${pkgs.procps}/bin/pkill yad
  fi

  get_nix_value() {
    ${pkgs.gawk}/bin/awk '
    /settings = {/ {inside_settings=1; next}
    inside_settings && /}/ {inside_settings=0}
    inside_settings && $0 ~ key {print gensub(/.*"([^"]+)".*/, "\\1", "g", $0)}
    ' key="$1" "${flakePath}"
  }

  _browser=$(get_nix_value "browser =")
  _terminal=$(get_nix_value "terminal =")
  _terminal_FM=$(get_nix_value "tuiFileManager =")

  ${pkgs.yad}/bin/yad \
    --center \
    --title="Hyprland Keybinds" \
    --no-buttons \
    --list \
    --width=745 \
    --height=920 \
    --column=Key: \
    --column=Description: \
    --column=Command: \
    --timeout-indicator=bottom \
    "SUPER Return" "Launch terminal" "$_terminal" \
    "SUPER T" "Launch terminal" "$_terminal" \
    "SUPER E" "Launch file manager" "$_terminal_FM" \
    "SUPER F" "Launch browser" "$_browser" \
    "SUPER SHIFT S" "Launch spotify" "spotify" \
    "CTRL ALT Delete" "Open system monitor" "$_terminal -e 'btop'" \
    "SUPER A" "Launch application menu" "launcher drun" \
    "SUPER SPACE" "Launch application menu" "launcher drun" \
    "SUPER SHIFT W" "Launch wallpaper menu" "launcher wallpaper" \
    "SUPER SHIFT T" "Launch tmux sessions" "launcher tmux" \
    "SUPER G" "Game launcher" "launcher games" \
    "SUPER F9" "Enable night mode" "hyprsunset --temperature 2500" \
    "SUPER F10" "Disable night mode" "pkill hyprsunset" \
    "SUPER CTRL C" "Colour picker" "hyprpicker --autocopy" \
    "SUPER, Left Click" "Move window with mouse" "movewindow" \
    "SUPER, Right Click" "Resize window with mouse" "resizewindow" \
    "SUPER SHIFT →" "Resize window right" "resizeactive 30 0" \
    "SUPER SHIFT ←" "Resize window left" "resizeactive -30 0" \
    "SUPER SHIFT ↑" "Resize window up" "resizeactive 0 -30" \
    "SUPER SHIFT ↓" "Resize window down" "resizeactive 0 30" \
    "SUPER SHIFT L" "Resize window right (HJKL)" "resizeactive 30 0" \
    "SUPER SHIFT H" "Resize window left (HJKL)" "resizeactive -30 0" \
    "SUPER SHIFT K" "Resize window up (HJKL)" "resizeactive 0 -30" \
    "SUPER SHIFT J" "Resize window down (HJKL)" "resizeactive 0 30" \
    "XF86MonBrightnessDown" "Decrease brightness" "brightnessctl set 2%-" \
    "XF86MonBrightnessUp" "Increase brightness" "brightnessctl set +2%" \
    "XF86AudioLowerVolume" "Lower volume" "pamixer -d 2" \
    "XF86AudioRaiseVolume" "Increase volume" "pamixer -i 2%" \
    "XF86AudioMicMute" "Mute microphone" "pamixer --default-source -t" \
    "SUPER M" "Mute microphone" "pamixer --default-source -t" \
    "XF86AudioMute" "Mute audio" "pamixer -t" \
    "XF86AudioPlay" "Play/Pause media" "playerctl play-pause" \
    "XF86AudioNext" "Next media track" "playerctl next" \
    "XF86AudioPrev" "Previous media track" "playerctl previous" \
    "SUPER Delete" "Exit Hyprland session" "exit" \
    "SUPER W" "Toggle floating window" "togglefloating" \
    "SUPER SHIFT G" "Toggle window group" "togglegroup" \
    "ALT Return" "Toggle fullscreen" "fullscreen" \
    "SUPER ALT L" "Lock screen" "hyprlock" \
    "SUPER Backspace" "Power menu" "wlogout -b 4" \
    "CTRL Escape" "Toggle Waybar" "pkill waybar || waybar" \
    "SUPER CTRL mouse_down" "zoom in" "zoom in" \
    "SUPER CTRL mouse_up" "zoom out" "zoom out" \
    "SUPER SHIFT N" "Open notification panel" "swaync-client -t -sw" \
    "SUPER SHIFT Q" "Open notification panel" "swaync-client -t -sw" \
    "SUPER Q" "Close active window" "killactive" \
    "ALT F4" "Force kill active window" "forcekillactive" \
    "SUPER Z" "Launch emoji picker" "launcher emoji" \
    "SUPER ALT K" "Change keyboard layout" "keyboardswitch" \
    "SUPER U" "Rebuild system" "$_terminal -e rebuild" \
    "SUPER ALT G" "Enable game mode" "gamemode" \
    "SUPER V" "Clipboard manager" "clipmanager" \
    "SUPER SHIFT M" "Online music" "rofimusic" \
    "SUPER SHIFT R" "Screen record (select area)" "screen-record a" \
    "SUPER CTRL R" "Screen record (select monitor)" "screen-record m" \
    "SUPER P" "Screenshot (select area)" "screenshot s" \
    "SUPER CTRL P" "Screenshot (frozen screen)" "screenshot sf" \
    "SUPER Print" "Screenshot (current monitor)" "screenshot m" \
    "SUPER ALT P" "Screenshot (all monitors)" "screenshot p" \
    "SUPER SHIFT CTRL ←" "Move window left" "movewindow l" \
    "SUPER SHIFT CTRL →" "Move window right" "movewindow r" \
    "SUPER SHIFT CTRL ↑" "Move window up" "movewindow u" \
    "SUPER SHIFT CTRL ↓" "Move window down" "movewindow d" \
    "SUPER CTRL S" "Move to scratchpad" "movetoworkspacesilent special" \
    "SUPER S" "Toggle scratchpad workspace" "togglespecialworkspace" \
    "SUPER Tab" "Cycle next window" "cyclenext" \
    "SUPER CTRL →" "Switch to next workspace" "workspace r+1" \
    "SUPER CTRL ←" "Switch to previous workspace" "workspace r-1" \
    "SUPER CTRL ↓" "Go to first empty workspace" "workspace empty" \
    "SUPER ←" "Move focus left" "movefocus l" \
    "SUPER →" "Move focus right" "movefocus r" \
    "SUPER ↑" "Move focus up" "movefocus u" \
    "SUPER ↓" "Move focus down" "movefocus d" \
    "ALT Tab" "Move focus down" "movefocus d" \
    "SUPER 1-0" "Switch to workspace 1-10" "workspace 1-10" \
    "SUPER ALT 10-20" "Switch to workspace 10-20" "workspace 10-20" \
    "SUPER SHIFT 1-0" "Move to workspace 1-10" "movetoworkspace 1-10"
''
