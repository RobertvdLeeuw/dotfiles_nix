#!/usr/bin/env bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 <workspace_number>"
  exit 1
fi

# Get the name of the currently focused monitor
focused_monitor=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused==true).name')

# Define workspace numbers based on monitor names
case $focused_monitor in
  "eDP-1")
    workspace=$(($1))
    ;;
  *)
    echo "Unknown monitor: $focused_monitor"
    exit 1
    ;;
esac

# Switch to the calculated workspace
echo $workspace
