#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 <workspace_number>"
  exit 1
fi

# Get the name of the currently focused monitor
focused_monitor=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused==true).name')

# Define workspace numbers based on monitor names
case $focused_monitor in
  "HDMI-A-1")
    workspace=$(($1))
    ;;
  "DP-1")
    workspace=$(($1 + 10))
    ;;
  "DP-3")
    workspace=$(($1 + 20))
    ;;
  *)
    echo "Unknown monitor: $focused_monitor"
    exit 1
    ;;
esac

# Switch to the calculated workspace
echo $workspace
