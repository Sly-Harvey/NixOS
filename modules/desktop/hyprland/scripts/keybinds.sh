#!/usr/bin/env bash

if pidof rofi >/dev/null; then
  pkill rofi
fi

if pidof yad >/dev/null; then
  pkill yad
fi

# get_nix_value() {
#     grep "$1" "$HOME/NixOS/flake.nix" | sed -E 's/.*"([^"]+)".*/\1/'
# }
get_nix_value() {
    awk '
    /settings = {/ {inside_settings=1; next} 
    inside_settings && /}/ {inside_settings=0} 
    inside_settings && $0 ~ key {print gensub(/.*"([^"]+)".*/, "\\1", "g", $0)}
    ' key="$1" "$HOME/NixOS/flake.nix"
}


_browser=$(get_nix_value "browser =")
_terminal=$(get_nix_value "terminal =")
_terminal_FM=$(get_nix_value "terminalFileManager =")

yad \
  --center \
  --title="Hyprland Keybinds" \
  --no-buttons \
  --list \
  --width=735 \
  --height=920 \
  --column=Key: \
  --column=Description: \
  --column=Command: \
  --timeout-indicator=bottom \
  "SUPER Return" "Launch terminal" "$_terminal" \
  "SUPER T" "Launch terminal" "$_terminal" \
  "SUPER E" "Launch file manager" "$_terminal_FM" \
  "SUPER F" "Launch browser" "$_browser" \
  "CTRL ALT Delete" "Open system monitor" "$_terminal -e 'btop'" \
  "SUPER A" "Launch application menu" "\$launcher" \
  "SUPER SPACE" "Launch application menu" "\$launcher" \
  "SUPER F9" "Enable night mode" "wlsunset -t 3000 -T 3900" \
  "SUPER F10" "Disable night mode" "pkill wlsunset" \
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
  "XF86AudioMute" "Mute audio" "pamixer -t" \
  "XF86AudioPlay" "Play/Pause media" "playerctl play-pause" \
  "XF86AudioNext" "Next media track" "playerctl next" \
  "XF86AudioPrev" "Previous media track" "playerctl previous" \
  "SUPER Q" "Close active window" "dontkillsteam.sh" \
  "ALT F4" "Close active window" "dontkillsteam.sh" \
  "SUPER Delete" "Exit Hyprland session" "exit" \
  "SUPER W" "Toggle floating window" "togglefloating" \
  "SUPER SHIFT G" "Toggle window group" "togglegroup" \
  "ALT Return" "Toggle fullscreen" "fullscreen" \
  "SUPER ALT L" "Lock screen" "hyprlock" \
  "SUPER Backspace" "Power menu" "wlogout -b 4" \
  "CTRL Escape" "Toggle Waybar" "pkill waybar || waybar" \
  "SUPER Z" "Launch emoji picker" "Scripts/emoji.sh" \
  "SUPER ALT K" "Change keyboard layout" "Scripts/keyboardswitch.sh" \
  "SUPER SHIFT N" "Open notification panel" "swaync-client -t -sw" \
  "SUPER SHIFT Q" "Open notification panel" "swaync-client -t -sw" \
  "SUPER CTRL ALT KP_Divide" "Rebuild" "exec, $_terminal -e Scripts/rebuild.sh" \
  "SUPER G" "Launch game launcher" "Scripts/gamelauncher.sh" \
  "SUPER ALT G" "Enable game mode" "Scripts/gamemode.sh" \
  "SUPER V" "Clipboard manager" "Scripts/ClipManager.sh" \
  "SUPER M" "Online music" "Scripts/rofimusic.sh" \
  "SUPER SHIFT M" "Online music" "Scripts/rofimusic.sh" \
  "SUPER P" "Screenshot (select area)" "Scripts/screenshot.sh s" \
  "SUPER CTRL P" "Screenshot (frozen screen)" "Scripts/screenshot.sh sf" \
  "SUPER Print" "Screenshot (current monitor)" "Scripts/screenshot.sh m" \
  "SUPER ALT P" "Screenshot (all monitors)" "Scripts/screenshot.sh p" \
  "SUPER SHIFT CTRL ←" "Move window left" "movewindow l" \
  "SUPER SHIFT CTRL →" "Move window right" "movewindow r" \
  "SUPER SHIFT CTRL ↑" "Move window up" "movewindow u" \
  "SUPER SHIFT CTRL ↓" "Move window down" "movewindow d" \
  "SUPER CTRL S" "Move to scratchpad" "movetoworkspacesilent special" \
  "SUPER S" "Toggle scratchpad workspace" "togglespecialworkspace" \
  "SUPER Tab" "Cycle next window" "cyclenext" \
  "SUPER Tab" "Bring active window to top" "bringactivetotop" \
  "SUPER CTRL →" "Switch to next workspace" "workspace r+1" \
  "SUPER CTRL ←" "Switch to previous workspace" "workspace r-1" \
  "SUPER CTRL ↓" "Go to first empty workspace" "workspace empty" \
  "SUPER ←" "Move focus left" "movefocus l" \
  "SUPER →" "Move focus right" "movefocus r" \
  "SUPER ↑" "Move focus up" "movefocus u" \
  "SUPER ↓" "Move focus down" "movefocus d" \
  "ALT Tab" "Move focus down" "movefocus d" \
  "SUPER 1-0" "Switch to workspace 1-10" "workspace 1-10" \
  "SUPER SHIFT 1-0" "Move window to workspace 1-10" "movetoworkspace 1-10" \
  "SUPER SHIFT 1-0" "Silently move window to workspace 1-10" "movetoworkspacesilent 1-10" \
