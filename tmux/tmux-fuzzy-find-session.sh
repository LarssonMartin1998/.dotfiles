#!/bin/zsh

# Run fzf-tmux in the background and serialize the input
(
current_session=$(tmux display-message -p '#S')
selected=$(tmux list-sessions -F '#S' | grep -v "$current_session" | fzf-tmux -p --expect=enter,del --header="Tmux Sessions (Ent/Del)")
echo "$selected" > /tmp/fzf-tmux-target
tmux refresh-client -S
) &

# Give some time for fzf to initiate and display
sleep 0.1
tmux refresh-client -S

# Wait for the fzf-tmux process to complete
wait

# Read the serialized input
selected=$(cat /tmp/fzf-tmux-target)
rm /tmp/fzf-tmux-target
key=$(head -n1 <<< "$selected")
target=$(tail -n +2 <<< "$selected")

# Check the pressed key and take appropriate action
case "$key" in
    enter)
        if [ -n "$target" ]; then
            tmux switch-client -t "$target"
            tmux display-message "Switched to session: $target"
        else
            tmux display-message "No session selected"
        fi
        ;;
    del)
        if [ -n "$target" ]; then
            tmux kill-session -t "$target"
            tmux display-message "Deleted session: $target"
        else
            tmux display-message "No session selected"
        fi
        ;;
    *)
        tmux display-message "Action cancelled"
        ;;
esac
