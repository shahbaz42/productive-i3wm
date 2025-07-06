#!/bin/bash

# If the block was clicked
if [[ "$BLOCK_BUTTON" ]]; then
    # Toggle DND
    dunstctl set-paused toggle
fi

# Get current DND status
status=$(dunstctl is-paused)

if [[ "$status" == "true" ]]; then
    echo " OFF"
else
    echo " ON"
fi
