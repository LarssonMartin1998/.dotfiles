#!/usr/bin/env bash

THEME=$(colorsync get)

OUTPUT="$HOME/.config/ghostty/colorsync_ghostty_theme"

default() {
    printf "theme = ayu" > "$OUTPUT"
}

case "$THEME" in
  ayudark)
    default
    ;;
  ayumirage)
    printf "theme = Ayu Mirage" > "$OUTPUT"
    ;;
  ayulight)
    printf "theme = ayu_light" > "$OUTPUT"
    ;;
  *)
    default
    ;;
esac

# once SIGUSR2 is merged in Ghostty, just replace the keystroke hack with pkill -USR2 ghostty
case "$(uname)" in
  Darwin)
    osascript -e 'tell application "System Events" to keystroke "," using {command down, shift down}'
    ;;
  Linux)
    wtype -M ctrl -M shift , -m shift -m ctrl
    ;;
  *)
    echo "Unsupported OS"
    ;;
esac
