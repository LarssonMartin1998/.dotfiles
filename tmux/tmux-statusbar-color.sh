#!/usr/bin/env bash

THEME=$(colorsync get)

default() {
    tmux set-option -g status-bg "#000000"
    tmux setw -g window-status-format "#[bg=#000000,fg=#BFBDB6] #[bold]#I #[default] #[fg=#59C2FF]#W #[default]"
    tmux setw -g window-status-current-format "#[bg=#95E6CB,fg=#000000] #[bold]#I #[default] #[fg=#FF8F40]#W #[default]"
}

case "$THEME" in
  ayudark)
    default
    ;;
  ayumirage)
    tmux set-option -g status-bg "#101521"
    tmux setw -g window-status-format "#[bg=#101521,fg=#CCCAC2] #[bold]#I #[default] #[fg=#73D0FF]#W #[default]"
    tmux setw -g window-status-current-format "#[bg=#95E6CB,fg=#101521] #[bold]#I #[default] #[fg=#FFCC66]#W #[default]"
    ;;
  ayulight)
    tmux set-option -g status-bg "#F0F0F0"
    tmux setw -g window-status-format "#[bg=#F0F0F0,fg=#5C6166] #[bold]#I #[default] #[fg=#399EE6]#W #[default]"
    tmux setw -g window-status-current-format "#[bg=#4CBF99,fg=#F0F0F0] #[bold]#I #[default] #[fg=#FA8D3E]#W #[default]"
    ;;
  *)
    default
    ;;
esac
