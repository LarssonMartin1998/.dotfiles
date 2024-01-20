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

# Enable the NULL_GLOB option to handle cases where no subdirectories exist
setopt NULL_GLOB

# Figure out the name for the lock-dir.
mkdir -p "$LOCK_ROOT"
latest_lock=0
for subdir in "$LOCK_ROOT"/*/; do
    subdir_name=${subdir%"${subdir##*[!/]}"}
    subdir_name=${subdir_name##*/}
    
    if [[ $subdir_name =~ ^[0-9]+$ ]] && ((subdir_name > highest_num)); then
        latest_lock=$subdir_name
    fi
done
((latest_lock++))

lock_dir="$LOCK_ROOT"/"$latest_lock"
# Create a lock dir for our current configs.

mkdir -p "$lock_dir"

# Iterate through the array of key-value pairs
for mapping in "${mappings[@]}"; do
    current_mapping=("${(@s:|:)mapping}")

    src="${current_mapping[1]}"
    dest="${current_mapping[2]}"
    lock_dest="$lock_dir/$(basename "$src")"

    # Check if destination directory exists
    final="$dest/$src"
    if [ -e "$final" ]; then
        # If destination exists, move its contents to the .lock directory
        mkdir -p "$lock_dest"
        mv "$final"/* "$lock_dest"
        echo "Moved existing contents of \"$final\" to \"$lock_dest\""
    fi

    # Create destination directory
    mkdir -p "$dest"

    # Copy source to destination
    cp -r "$src" "$dest"
done
