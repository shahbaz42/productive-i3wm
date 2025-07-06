#!/bin/bash

# Toggle mute on click
if [[ "$BLOCK_BUTTON" ]]; then
    pactl set-sink-mute @DEFAULT_SINK@ toggle
fi

# Get mute status
if pactl get-sink-mute @DEFAULT_SINK@ | grep -q yes; then
    echo " Mute"  # Muted
else
    # Get volume percentage (just the number)
    vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | tr -d '%')

    # Pick icon based on volume level
    if (( vol == 0 )); then
        icon=""  # Muted
    elif (( vol <= 30 )); then
        icon=""  # Low volume
    else
        icon=""  # High volume
    fi

    echo "$icon ${vol}%"
fi

# Optional: force redraw on click
# pkill -RTMIN+10 i3blocks
