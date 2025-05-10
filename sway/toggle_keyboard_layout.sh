#!/usr/bin/env bash

# Toggle between US (0) and Swedish (1) layouts
current=$(swaymsg -t get_inputs | jq -r '.[] | select(.type=="keyboard") | .xkb_active_layout_index' | head -n 1)

if [ "$current" -eq 0 ]; then
    swaymsg input '*' xkb_switch_layout 1
else
    swaymsg input '*' xkb_switch_layout 0
fi
