#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 <direction>"
  exit 1
fi

# Get the name of the currently focused monitor
focused_workspace=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused==true).name')
index=$(($focused_workspace % 10))

# Define workspace numbers based on monitor names
if [ "$1" == "l" ] && [ "$index" != "1" ]; then
  workspace=$(($focused_workspace - 1))
elif [ "$1" == "r" ] && [ "$index" != "5" ]; then
  workspace=$(($focused_workspace + 1))
else
  workspace=$focused_workspace
fi

# Switch to the calculated workspace
echo $workspace
