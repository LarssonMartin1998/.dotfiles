#!/usr/bin/env bash

LOCK_FILE="/tmp/resolution_updater.lock"

# Remove any stale lock file at startup
[ -f "$LOCK_FILE" ] && rm -f "$LOCK_FILE"

remove_lock() {
    if [ -f "$LOCK_FILE" ]; then
        rm -f "$LOCK_FILE"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Lock file removed"
    fi
}

trap remove_lock EXIT INT TERM

update_display() {
    if [ -f "$LOCK_FILE" ]; then
        # Check lock file age
        lock_age=$(($(date +%s) - $(stat -c %Y "$LOCK_FILE")))
        if [ $lock_age -gt 10 ]; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') - Stale lock file detected (${lock_age}s old), removing"
            remove_lock
        else
            echo "$(date '+%Y-%m-%d %H:%M:%S') - Lock file exists (${lock_age}s old), skipping update"
            return
        fi
    fi

    # Process each output and determine if changes are needed
    local changes_needed=false
    
    local output_data=$(swaymsg -t get_outputs -r)
    
    # Process each output
    echo "$output_data" | jq -r '.[] | 
        {
            name: .name, 
            current_mode: {
                width: .current_mode.width,
                height: .current_mode.height,
                refresh: .current_mode.refresh
            },
            current_scale: .scale,
            modes: .modes
        } | 
        .best_mode = (.modes | map({width, height, refresh, pixels: (.width * .height)}) | sort_by(-.pixels, -.refresh) | first) |
        "\(.name)|\(.current_mode.width)|\(.current_mode.height)|\(.current_mode.refresh)|\(.current_scale)|\(.best_mode.width)|\(.best_mode.height)|\(.best_mode.refresh)"
    ' | while IFS="|" read -r name curr_width curr_height curr_refresh curr_scale best_width best_height best_refresh; do
        # Determine target scale based on best resolution
        target_scale=1
        if [ "$best_height" -ge 2160 ]; then
            target_scale=1.5
        fi
        
        # Convert refresh rates to integers for comparison
        curr_refresh_int=$(echo "$curr_refresh/1000" | bc)
        best_refresh_int=$(echo "$best_refresh/1000" | bc)
        
        # Check if changes needed for this display
        if [ "$curr_width" -ne "$best_width" ] ||
           [ "$curr_height" -ne "$best_height" ] || 
           [ "$curr_refresh_int" -ne "$best_refresh_int" ]; then
            
            touch "$LOCK_FILE"
            changes_needed=true
            
            echo "$(date '+%Y-%m-%d %H:%M:%S') - Changing $name from ${curr_width}x${curr_height}@${curr_refresh_int}Hz (scale ${curr_scale}) to ${best_width}x${best_height}@${best_refresh_int}Hz (scale ${target_scale})"
            
            # Apply the resolution change
            swaymsg output "$name" mode "${best_width}x${best_height}@${best_refresh_int}Hz"
            
            # Apply scaling
            swaymsg output "$name" scale $target_scale
        else
            echo "$(date '+%Y-%m-%d %H:%M:%S') - No changes needed for $name - already at optimal settings"
        fi
    done
    
    # Remove lock file after a delay if changes were made
    if $changes_needed; then
        # Use a function for lock removal with delay
        (sleep 3 && remove_lock) &
    fi
}

swaymsg -m -t subscribe '["output"]' | jq --unbuffered -r '.change' | while read -r change; do
    if [[ "$change" == "unspecified" || "$change" == "reconnect" || "$change" == "mode" ]]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Display change detected: $change"
        sleep 1
        update_display
    fi
done
