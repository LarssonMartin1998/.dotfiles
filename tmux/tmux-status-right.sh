format_for_tmux() {
    fg="#1F2430"
    bg="#73D0FF"
    text_col="#CCCAC2"
    echo $1 | awk -v bg="$bg" -v fg="$fg" -v text_col="$text_col" '{printf("#[default]#[fg="bg"]#[default]#[bg="bg", fg="fg"]%s#[default]#[fg="bg"]#[default]#[fg="text_col"] %s", substr($0, 1, 1), substr($0, 2))}' 
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
