source_pane=$(tmux display-message -p '#{pane_id}')
target_window=$1

window_exists=$(tmux list-windows -F '#I' | grep "^$target_window$")

if [ -z "$window_exists" ]; then
    tmux break-pane -d -t $target_window
else
    target_pane=$(tmux list-panes -t $target_window -F '#{pane_id}' | sort | tail -n 1)
    tmux join-pane -d -s $source_pane -t $target_pane
    tmux select-layout -t $target_window main-vertical
fi
