#!/bin/zsh

LOCK_ROOT=".lock"

# Define a function to create key-value pairs
create_mapping() {
    local input="$1"
    local output="$2"
    echo "$input|$output"
}

# Define an array of key-value pairs
mappings=(
    $(create_mapping "nvim" "$HOME/.config")
    $(create_mapping "kitty" "$HOME/.config")
    $(create_mapping ".zshrc" "$HOME")
    $(create_mapping "yabai" "$HOME/.config")
    $(create_mapping "yabai_launcher" "/private/etc/sudoers.d")
)

function get_latest_lock() {
    local latest_lock=0
    for subdir in "$LOCK_ROOT"/*/; do
        subdir_name=${subdir%"${subdir##*[!/]}"}
        subdir_name=${subdir_name##*/}
        
        if [[ $subdir_name =~ ^[0-9]+$ ]] && ((subdir_name > latest_lock)); then
            latest_lock=$subdir_name
        fi
    done

    echo $latest_lock
}
