#!/usr/bin/env bash

HEADPHONES="bluez_output.80:C3:BA:65:D6:34"
HEADPHONES_MAC="80:C3:BA:65:D6:34"
SPEAKERS="alsa_output.pci-0000_0b_00.4.analog-stereo"

if ! bluetoothctl info "$HEADPHONES_MAC" | grep -q "Connected: yes"; then
  exit 0
fi

current=$(pactl get-default-sink)

if [[ "$current" == "$HEADPHONES" ]]; then
  pactl set-default-sink "$SPEAKERS"
else
  pactl set-default-sink "$HEADPHONES"
fi
