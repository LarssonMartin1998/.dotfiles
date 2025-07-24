#!/usr/bin/env bash
set -euo pipefail

ROOT="$HOME/.local/state/colorsync"
TRIGGER_NAME="tmux_statusbar_color"
SCRIPT="$HOME/.config/tmux/tmux-statusbar-color.sh"
WATCHMAN="watchman"

"$WATCHMAN" watch-project "$ROOT" >/dev/null
"$WATCHMAN" -- trigger-del "$ROOT" "$TRIGGER_NAME" >/dev/null 2>&1 || true
"$WATCHMAN" -- trigger "$ROOT" "$TRIGGER_NAME" 'current' -- bash "$SCRIPT"
# watchman -- trigger  "$HOME/.local/state/colorsync" tmux_statusbar_color 'current' -- bash "$HOME/.config/tmux/tmux-statusbar-color.sh"

# watchman watch-project "$HOME/.local/state/colorsync"
