#!/usr/bin/env python3

# This script requires the i3ipc-python package.
# It makes inactive windows semi-transparent and focused windows fully opaque.

import i3ipc
import signal
import sys

# --- Configuration ---
UNFOCUSED_OPACITY = 0.875  # Opacity for unfocused windows (0.0 to 1.0)
FOCUSED_OPACITY = 1.0     # Opacity for focused windows (should generally be 1.0)
# --- End Configuration ---

ipc = i3ipc.Connection()
prev_focused_win_id = None

def set_opacity(win_container, opacity_value):
    """Safely sets opacity for a window container."""
    if win_container:
        win_container.command(f'opacity {opacity_value}')

def initialize_opacities():
    """Sets initial opacity for all windows based on focus state."""
    global prev_focused_win_id
    try:
        for window in ipc.get_tree().leaves(): # Iterate over actual windows
            if window.focused:
                set_opacity(window, FOCUSED_OPACITY)
                prev_focused_win_id = window.id
            else:
                set_opacity(window, UNFOCUSED_OPACITY)
    except Exception as e:
        print(f"Error during initialization: {e}")


def on_window_focus(ipc_connection, event):
    """Handles window focus changes to adjust opacity."""
    global prev_focused_win_id
    
    try:
        focused_window = event.container
        
        if focused_window:
            # Set newly focused window to full opacity
            set_opacity(focused_window, FOCUSED_OPACITY)

            # Set previously focused window (if it exists and is different) to unfocused opacity
            if prev_focused_win_id is not None and prev_focused_win_id!= focused_window.id:
                # Find the previously focused window by its ID
                prev_window_node = ipc_connection.get_tree().find_by_id(prev_focused_win_id)
                if prev_window_node: # Check if previous window still exists
                    set_opacity(prev_window_node, UNFOCUSED_OPACITY)
            
            prev_focused_win_id = focused_window.id
        elif prev_focused_win_id is not None: # Current focus is not a window (e.g., empty workspace)
            # Ensure the last focused window becomes unfocused if focus is lost to non-window
            prev_window_node = ipc_connection.get_tree().find_by_id(prev_focused_win_id)
            if prev_window_node:
                set_opacity(prev_window_node, UNFOCUSED_OPACITY)
            prev_focused_win_id = None # No window is currently focused

    except Exception as e:
        print(f"Error in on_window_focus: {e}")


def signal_handler(sig, frame):
    """Gracefully exits on SIGINT or SIGTERM."""
    print("Opacity script exiting...")
    # Optional: Reset all opacities to 1.0 on exit
    try:
        for window in ipc.get_tree().leaves():
            set_opacity(window, 1.0)
    except Exception as e:
        print(f"Error resetting opacities on exit: {e}")
    finally:
        ipc.main_quit()
        sys.exit(0)

if __name__ == '__main__':
    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)

    initialize_opacities()
    ipc.on("window::focus", on_window_focus)
    # Consider also listening to "window::close" to update prev_focused_win_id if it closes.
    # ipc.on("window::close", on_window_close) # Example, implementation needed
    ipc.main()
