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

    # Battery status and power consumption
    battery_path="/sys/class/power_supply/macsmc-battery"
    if [ -d "$battery_path" ]; then
        battery_capacity=$(cat $battery_path/capacity)
        power_consumption=$(cat $battery_path/power_now) # in microwatts
        power_consumption_watts=$(echo "scale=2; $power_consumption / 1000000" | bc)
        battery="Battery: $battery_capacity% ($power_consumption_watts W)"
    else
        battery="Battery: N/A"
    fi

    # Brightness status
    brightness=$(brightnessctl | grep -oP '[0-9]+(?=%)')
    brightness_status="Brightness: $brightness%"

    bluetooth_device=$(bluetoothctl devices Connected | awk '{$1=$2=""; print $0}' | sed 's/^ *//g')
    if [ -z "$bluetooth_device" ]; then
        bluetooth_status=""
    else
        bluetooth_status="Bluetooth: $bluetooth_device"
    fi

    # Combine all statuses
    final_status=""
    if [ -n "$bluetooth_status" ]; then
        final_status="$bluetooth_status | "
    fi
    final_status="$final_status$brightness_status | $battery | $network_status | $date_time "
    echo "$final_status"

    sleep 1
done

