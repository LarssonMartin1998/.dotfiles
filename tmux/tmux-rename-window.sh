# program blacklist
# program=$(
#   ps -o comm= -t "$(tmux display-message -p '#{pane_tty}')" 2>/dev/null \
#     | grep -v '^ps$' \
#     | grep -v 'tmux-rename-window' \
#     | grep -v 'tail' \
#     | grep -v 'head' \
#     | grep -v 'grep' \
#     | grep -v 'find' \
#     | grep -v 'rg' \
#     | grep -v 'jq' \
#     | grep -v 'perl' \
#     | grep -v 'fzf' \
#     | grep -v 'bat' \
#     | grep -v 'cat' \
#     | grep -v 'tldr' \
#     | grep -v 'man' \
#     | tail -n1
# )

# Fallback if empty:
# [[ -z "$program" ]] && program="zsh"

# Get the current working directory
cwd=$(tmux display-message -p '#{pane_current_path}')

# If the program is zsh (or bash, etc.), show dir name
# if [[ "$program" == "zsh" || "$program" == "bash" || "$program" == "sh" ]]; then
    [[ "$cwd" == "$HOME" ]] && dirname="~" || dirname=$(basename "$cwd")
    name="$dirname/"
# else
#     name="$program"
# fi

# Now do your truncation/padding
MAX_WIDTH=15
if [ "${#name}" -gt "$MAX_WIDTH" ]; then
  truncated="${name:0:$(($MAX_WIDTH-2))}…/"
  echo "$truncated"
else
  echo "$name"
fi

