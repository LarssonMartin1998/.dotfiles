#!/bin/bash

#############################
# Icons for Linux Battery
#############################
# This icon is used for macOS (no dynamic levels).
MAC_BATTERY_ICON=""

# Charging icon (positive power_now)
BATTERY_CHARGING_ICON="󰂄"

# Discharging icons based on capacity
BATTERY_FULL_ICON=""     # 80%–100%
BATTERY_3QTR_ICON=""     # 60%–79%
BATTERY_HALF_ICON=""     # 40%–59%
BATTERY_QTR_ICON=""      # 20%–39%
BATTERY_EMPTY_ICON=""    # 0%–19%

#############################
# macOS Battery
#############################
get_battery_info_mac() {
    # pmset is the standard battery command on macOS
    if ! command -v pmset &>/dev/null; then
        return 1
    fi

    capacity=$(pmset -g batt | grep -o "\d\+%" | head -n1 | tr -d '%')
    if [[ -n "$capacity" ]]; then
        # Just show generic icon + capacity on mac
        echo "$MAC_BATTERY_ICON  $capacity%"
        return 0
    fi
    
    return 1
}

#############################
# Linux Battery
#############################
get_battery_info_linux() {
    local path="$1"
    
    # Early return if path is not valid
    if [ -z "$path" ]; then
        return 1
    fi

    # capacity
    if [ -r "$path/capacity" ]; then
        capacity=$(cat "$path/capacity")
    else
        capacity=""
    fi
    
    # power_now
    power_now=""
    if [ -r "$path/power_now" ]; then
        power_now=$(cat "$path/power_now")
    elif [ -r "$path/current_now" ] && [ -r "$path/voltage_now" ]; then
        # Some systems use current_now and voltage_now
        current_now=$(cat "$path/current_now")
        voltage_now=$(cat "$path/voltage_now")
        if [[ -n "$current_now" && -n "$voltage_now" ]]; then
            # (current_now * voltage_now) / 1e6 => watts
            power_now=$(echo "scale=2; ($current_now * $voltage_now) / 1000000" | bc)
        fi
    fi

    # If we got capacity at all
    if [[ -n "$capacity" ]]; then

        # Figure out numeric or empty power
        if [[ -n "$power_now" ]]; then
            # Determine if power_now is micro- or milliwatts
            abs_power_now=${power_now#-}  # remove leading '-' if present
            if (( abs_power_now > 10000 )); then
                # microwatts -> W
                power_consumption_watts=$(echo "scale=2; $power_now / 1000000" | bc)
            else
                # milliwatts -> W
                power_consumption_watts=$(echo "scale=2; $power_now / 1000" | bc)
            fi
        fi

        # Decide if charging or discharging
        # (If power_now > 0 => charging, < 0 => discharging)
        local battery_icon
        if [[ -n "$power_now" ]]; then
            # numeric check: is it > 0 or < 0?
            float_power=$(echo "$power_now" | sed 's/^+//; s/,/./')
            # strip any trailing newline, just in case
            if (( $(echo "$float_power > 0" | bc -l) )); then
                # CHARGING
                battery_icon="$BATTERY_CHARGING_ICON"
            else
                # DISCHARGING - pick icon by capacity
                battery_icon=$(pick_battery_icon "$capacity")
            fi
        else
            # Unknown or no power_now => treat as discharging
            battery_icon=$(pick_battery_icon "$capacity")
        fi

        # Build the final string
        if [[ -n "$power_consumption_watts" ]]; then
            echo "$battery_icon  $capacity% (${power_consumption_watts} W)"
        else
            echo "$battery_icon  $capacity%"
        fi
        return 0
    fi

    return 1
}

#############################
# Helper to pick icon by capacity
#############################
pick_battery_icon() {
    local cap="$1"
    # convert to integer
    if [ "$cap" -ge 80 ]; then
        echo "$BATTERY_FULL_ICON"
    elif [ "$cap" -ge 60 ]; then
        echo "$BATTERY_3QTR_ICON"
    elif [ "$cap" -ge 40 ]; then
        echo "$BATTERY_HALF_ICON"
    elif [ "$cap" -ge 20 ]; then
        echo "$BATTERY_QTR_ICON"
    else
        echo "$BATTERY_EMPTY_ICON"
    fi
}

#############################
# Gather battery info
#############################
get_battery_info_linux_main() {
    battery_paths=(
        "/sys/class/power_supply/macsmc-battery"  # Asahi (M1) Fedora Remix
        "/sys/class/power_supply/BAT0"           # Standard Linux
        "/sys/class/power_supply/BAT1"           # Common secondary
    )
    
    for path in "${battery_paths[@]}"; do
        if [ -d "$path" ]; then
            battery_info=$(get_battery_info_linux "$path")
            if [ $? -eq 0 ]; then
                echo "$battery_info"
                return
            fi
        fi
    done
}

#############################
# Main logic
#############################
OS="$(uname)"
case "$OS" in
    Darwin)
        battery=$(get_battery_info_mac)
        ;;
    Linux)
        battery=$(get_battery_info_linux_main)
        ;;
    *)
        # Unsupported OS, no output
        battery=""
        ;;
esac

echo "$battery"
