is_integer() {
    local input=$1
    [[ $input =~ ^-?[0-9]+$ ]]
}

wallpaper_history_path="$HOME/.wallpaper_history"

function set_wallpaper() {
    local wallpaper_path="$1"
    local history_size="$2"
    local monitor="DP-1"

    hyprctl hyprpaper wallpaper "$monitor, $wallpaper_path"

    if [ $history_size -le 1 ]; then
        echo "Won't set wallpaper, history size is less than or equal to 1"
        return
    fi

    local -a wallpapers
    if [ -f "$wallpaper_history_path" ]; then
        mapfile -t wallpapers < "$wallpaper_history_path"
    fi

    wallpapers+=("$wallpaper_path")
    if [ ${#wallpapers[@]} -gt $history_size ]; then
        wallpapers=("${wallpapers[@]: -$history_size}")
    fi

    printf "%s\n" "${wallpapers[@]}" > "$wallpaper_history_path"
}

wallpaper_dir="$HOME/dev/git/.dotfiles/wallpapers/catppuccin"
files=($wallpaper_dir/*)

history_size=1
if [ $# -eq 1 ]; then
    if is_integer "$1"; then
        history_size=$1
        if [ $history_size -lt 1 ]; then
            echo "History size must be greater than 0"
            exit 1
        fi

        if [ ${#files[@]} -le $history_size ]; then
            echo "Number of wallpapers is less than or equal to the history size"
            exit 1
        fi
    else
        echo "Invalid argument: $1"
        exit 1
    fi
fi

if [ ${#files[@]} -eq 1 ]; then
    set_wallpaper "${files[0]}" 0
    exit 0
fi

if [ -f "$wallpaper_history_path" ]; then
    mapfile -t history < "$wallpaper_history_path"

    for hist_wallpaper in "${history[@]}"; do
        for i in "${!files[@]}"; do
            if [[ "${files[$i]}" == "$hist_wallpaper" ]]; then
                unset 'files[i]'
            fi
        done
        echo "Removing $hist_wallpaper"
    done
    
    # Re-create the files array to eliminate gaps
    files=("${files[@]}")
fi

array_length=${#files[@]}
if [ $array_length -eq 0 ]; then
    echo "No wallpapers available after filtering."
    exit 1
fi

array_length=${#files[@]}
index=$(($RANDOM % $array_length))
set_wallpaper "${files[$index]}" $history_size
