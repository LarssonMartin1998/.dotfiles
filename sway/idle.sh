#!/bin/bash

# Track the current inhibition state
inhibited=0

# Check player status and adjust idle inhibition
while true; do
  if playerctl status | grep -q "Playing"; then
    if [ "$inhibited" -eq 0 ]; then
      swaymsg "inhibit_idle on"
      inhibited=1
    fi
  else
    if [ "$inhibited" -eq 1 ]; then
      swaymsg "inhibit_idle off"
      inhibited=0
    fi
  fi
  sleep 5  # Check every 5 seconds
done &
exec swayidle -w \
     timeout 300 'swaylock -f -c 000000' \
     timeout 600 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' \
     before-sleep 'swaylock -f -c 000000'
