#!/bin/bash

while true; do
  # Get the currently focused window's title
  focused_title=$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true).name')

  # If the focused window matches our criteria, monitor it
  if [[ "$focused_title" == "Audio Menu" || "$focused_title" == "Set Volume" || "$focused_title" == "Select Input Device" || "$focused_title" == "Select Output Device" ]]; then
    # Get the ID of the focused window
    focused_id=$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true).id')

    # Monitor for focus change
    while swaymsg -t subscribe '[ "window" ]' | jq -r 'select(.change == "focus").container.id' | grep -v "$focused_id"; do
      # Close the window if focus is lost
      swaymsg "[con_id=$focused_id]" kill
      break
    done
  fi

  # Small delay to prevent high CPU usage
  sleep 0.1
done
