#!/usr/bin/env bash

THEME=$(colorsync get)

default() {
    tmux set-option -g status-bg "#0b0b2b"
    tmux setw -g window-status-format "#[bg=#0b0b2b,fg=#eeeef5] #[bold]#I #[default] #[fg=#34BFA4]#W #[default]"
    tmux setw -g window-status-current-format "#[bg=#34BFA4,fg=#020222] #[bold]#I #[default] #[fg=#D4973E]#W #[default]"
}

case "$THEME" in
  norrsken)
    default
    ;;
  *)
    default
    ;;
esac
