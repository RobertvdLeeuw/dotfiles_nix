#!/bin/bash

# Get the current volume
CURRENT_VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | tr -d '%')

# Define the increment step
INCREMENT=1

# Check if the current volume is less than 100
if [ "$CURRENT_VOLUME" -lt 100 ]; then
  # Calculate the new volume
  NEW_VOLUME=$(($CURRENT_VOLUME + $INCREMENT))

  # Set the new volume
  pactl set-sink-volume @DEFAULT_SINK@ ${NEW_VOLUME}%
fi
