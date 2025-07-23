THEME=$(colorsync get)

default() {
    bg="#95E6CB"
    fg="#000000"
    text_col="#BFBDB6"
}

case "$THEME" in
  ayudark)
      default
    ;;
  ayumirage)
    bg="#95E6CB"
    fg="#101521"
    text_col="#CCCAC2"
    ;;
  ayulight)
    bg="#4CBF99"
    fg="#F3F4F5"
    text_col="#5C6166"
    ;;
  *)
      default
    ;;
esac

format_for_tmux() {
    echo $1 | gawk -v bg="$bg" -v fg="$fg" -v text_col="$text_col" '{printf("#[default]#[fg="bg"]#[default]#[bg="bg", fg="fg", bold]%s #[default]#[fg="bg"]#[default]#[fg="text_col"] %s", substr($0, 1, 1), substr($0, 2))}' 
}

battery_result=$($HOME/.config/confutils/get-battery.sh)

space="    "
session=$(format_for_tmux "#S")
calendar=$(format_for_tmux " $(date +"%a %b %d")")

if [ -n "$battery_result" ]; then
    battery=$(format_for_tmux "$battery_result")
    echo $session$space$battery$space$calendar
else
    echo $session$space$calendar
fi
