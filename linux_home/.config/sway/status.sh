#!/bin/zsh
# Icons
vpn_icon=""
wifi_icon=" "
brightness_icon=""
bluetooth_icon=""
keyboard_icon="⌨"
date_icon=""

while true; do
    # VPN (Mullvad)
    vpn_status=$(mullvad status)
    is_connected=$(echo "$vpn_status" | grep -c "Connected")
    if [ "$is_connected" -eq 1 ]; then
        visible_location=$(echo "$vpn_status" | grep -oP "Visible location:\s+\K.*" | cut -d. -f1)
        vpn_display="$vpn_icon $visible_location"
    else
        vpn_display="$vpn_icon Disconnected"
    fi

    # Network status
    ssid=$(nmcli -t -f ACTIVE,SSID dev wifi | grep -E '^yes' | cut -d: -f2)
    if [ -z "$ssid" ]; then
        network_display="$wifi_icon Disconnected"
    else
        network_display="$wifi_icon $ssid"
    fi

    # Date/time
    date_time_icon="$date_icon $(date +"%a %b %d, %H:%M")"

    # Battery
    battery=$("$HOME/.config/confutils/get-battery.sh")

    # Brightness
    brightness=$(brightnessctl | grep -oP '[0-9]+(?=%)')
    brightness_display="$brightness_icon $brightness%"

    # Bluetooth
    bluetooth_device=$(bluetoothctl devices Connected \
        | awk '{$1=$2=""; print $0}' \
        | sed 's/^ *//g')
    if [ -z "$bluetooth_device" ]; then
        bluetooth_display=""
    else
        bluetooth_display="$bluetooth_icon $bluetooth_device"
    fi

    # Keyboard layout
    language_index=$(swaymsg -t get_inputs | jq -r '.[] | select(.type=="keyboard") | .xkb_active_layout_index' | head -n 1)
    if [ "$language_index" -eq 0 ]; then
        keyboard_layout="US"
    else
        keyboard_layout="SE"
    fi
    keyboard_display="$keyboard_icon $keyboard_layout"

    # Combine all statuses, separated by tabs (\t).
    # - In zsh, you can do literal tabs with $'\t' 
    final_status=""
    if [ -n "$bluetooth_display" ]; then
        final_status="$bluetooth_display"
    fi

    space="    "
    final_status="$final_status$space$brightness_display"
    final_status="$final_status$space$battery"
    final_status="$final_status$space$keyboard_display"
    final_status="$final_status$space$vpn_display"
    final_status="$final_status$space$network_display"
    final_status="$final_status$space$date_time_icon"
    final_status="$final_status "

    echo "$final_status"
    sleep 1
done
