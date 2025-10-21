#!/run/current-system/sw/bin/bash

export SHELL=/run/current-system/sw/bin/bash

MODE_FILE="$HOME/.config/hypr/power_mode"

if [[ ! -s "$MODE_FILE" ]]; then
    echo "performance" > "$MODE_FILE"
fi

CURRENT=$(cat "$MODE_FILE")

if [[ "$CURRENT" == "performance" ]]; then
    NEW_MODE="powersave"
    CMD="pkexec tlp bat"
else
    NEW_MODE="performance"
    CMD="pkexec tlp ac"
fi

if $CMD > /dev/null 2>&1; then
    echo "$NEW_MODE" > "$MODE_FILE"
fi

exit 0
