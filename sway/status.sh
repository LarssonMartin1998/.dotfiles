#!/bin/zsh
# Icons
vpn_icon=""
wifi_icon=" "
brightness_icon=""
bluetooth_icon=""
keyboard_icon="⌨"
date_icon=""
volume_icon=""
muted_icon=""

# --- Added for Signal Handling ---
# File to store the PID of this script
status_pid_file="/tmp/swaybar_status_pid"

# Function to update the status and print it
update_status() {
	# VPN (Mullvad)
	vpn_status=$(mullvad status)
	is_connected=$(echo "$vpn_status" | grep -c "Connected")
	if [ "$is_connected" -eq 1 ]; then
		visible_location=$(echo "$vpn_status" | grep -oP "Visible location:\s+\K.*" | cut -d. -f1)
		vpn_display="$vpn_icon  $visible_location"
	else
		vpn_display="$vpn_icon  Disconnected"
	fi

	# Network status
	ssid=$(nmcli -t -f ACTIVE,SSID dev wifi | grep -E '^yes' | cut -d: -f2)
	if [ -z "$ssid" ]; then
		network_display="$wifi_icon  Disconnected"
	else
		network_display="$wifi_icon  $ssid"
	fi

	# Date/time
	date_time_icon="$date_icon  $(date +"%a %b %d, %H:%M")"

	# Battery
	battery=$("$HOME/.config/confutils/get-battery.sh")

	# Brightness
	brightness=$(brightnessctl | grep -oP '[0-9]+(?=%)')
	brightness_display="$brightness_icon  $brightness%"

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
		keyboard_layout="SE" # Assuming SE is index 1
	fi
	keyboard_display="$keyboard_icon $keyboard_layout"

    volume_output=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
    is_muted=$(echo "$volume_output" | grep -c "MUTED")
    if [ "$is_muted" -eq 1 ]; then
        volume_display="$muted_icon Muted"
    else
        # Extract decimal volume (e.g., 0.75) and convert to percentage
        volume_decimal=$(echo "$volume_output" | awk '{print $2}')
        # Use awk to multiply by 100 and format as an integer percentage
        volume_percent=$(awk -v vol="$volume_decimal" 'BEGIN {printf "%.0f", vol * 100}')
        volume_display="$volume_icon   $volume_percent%"
    fi

	# Combine all statuses
	final_status=""
	if [ -n "$bluetooth_display" ]; then
		final_status="$bluetooth_display"
	fi

	space="   " # Using standard spaces for separation
	final_status="$final_status$space$volume_display"
	final_status="$final_status$space$brightness_display"
	final_status="$final_status$space$battery"
	final_status="$final_status$space$keyboard_display"
	final_status="$final_status$space$vpn_display"
	final_status="$final_status$space$network_display"
	final_status="$final_status$space$date_time_icon"
	final_status="$final_status " # Trailing space

	# Print the status followed by a newline
	echo "$final_status"
}

# --- Added for Signal Handling ---
# Write the script's PID to the file so we can signal it
echo $$ > "$status_pid_file"

# Trap a real-time signal (e.g., SIGRTMIN+8) to trigger an immediate update
# When this signal is received, the 'update_status' function is executed
trap 'update_status' 42

# Main loop
while true; do
	update_status # Perform the regular update
	sleep 1
done

# Clean up the PID file on exit (optional but good practice)
trap 'rm "$status_pid_file"' EXIT
