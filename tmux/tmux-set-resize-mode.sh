#!/bin/zsh

desired_state=$1
current_state=$(tmux show-environment -g @resize_mode 2>/dev/null | cut -d '=' -f 2)

[ "$current_state" = "$desired_state" ] && exit 0

tmux set -g @tmux_resize_mode $desired_state
if [ "$desired_state" = "1" ]; then
    tmux display-message "Resize mode ON"
else
    tmux display-message "Resize mode OFF"
fi
