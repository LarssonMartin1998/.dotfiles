#!/usr/bin/env bash

watchman watch-project "$HOME/.local/state/colorsync"
watchman -- trigger  "$HOME/.local/state/colorsync" tmux_statusbar_color 'current' -- bash "$HOME/.config/tmux/tmux-statusbar-color.sh"
