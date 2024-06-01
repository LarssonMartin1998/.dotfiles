#!/bin/sh

while true; do
    # Network status
    ssid=$(nmcli -t -f ACTIVE,SSID dev wifi | grep -E '^yes' | cut -d: -f2)
    if [ -z "$ssid" ]; then
        network_status="WiFi: Disconnected"
    else
        network_status="WiFi: $ssid"
    fi

    # Date and time
    date_time=$(date +"%Y-%m-%d %H:%M")

    # Battery status
    battery_path="/sys/class/power_supply/macsmc-battery"
    if [ -d "$battery_path" ]; then
        battery_capacity=$(cat $battery_path/capacity)
        battery_status=$(cat $battery_path/status)
        battery="Battery: $battery_capacity% ($battery_status)"
    else
        battery="Battery: N/A"
    fi

    # Brightness status
    brightness=$(brightnessctl | grep -oP '[0-9]+(?=%)')
    brightness_status="Brightness: $brightness%"

    # Combine all statuses
    echo "$battery | $network_status | $brightness_status | $date_time "

    sleep 1
done

