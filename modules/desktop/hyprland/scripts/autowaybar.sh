#!/usr/bin/env bash

UID=$(id -u)

# Function to check if workspace is empty
check_workspace_empty() {
    # Get active workspace ID
    active_workspace=$(hyprctl activeworkspace -j | jq '.id')
    
    # Get all clients (windows) in the active workspace
    clients=$(hyprctl clients -j | jq "[.[] | select(.workspace.id == $active_workspace)]")
    
    # Return 0 if empty, 1 if windows present
    [ "$(echo "$clients" | jq 'length')" -eq 0 ]
}

# Function to show Waybar
show_waybar() {
    if ! pgrep "waybar" > /dev/null; then
        waybar &
    fi
}

# Function to hide Waybar
hide_waybar() {
    pkill waybar
}

# Main logic to toggle Waybar
toggle_waybar() {
    if check_workspace_empty; then
        hide_waybar
    else
        show_waybar
    fi
}

# Initial check
toggle_waybar

# Listen to Hyprland events using NixOS socket path
socat -U - UNIX-CONNECT:/run/user/$UID/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r event; do
    # Log events for debugging
    # echo "Event: $event at $(date)" >> "$LOG_FILE"
    case "$event" in
        workspace* | openwindow* | closewindow* | activewindow*)
            toggle_waybar
            # Small delay to prevent rapid event stacking
            # sleep 0.05
            ;;
    esac
done
