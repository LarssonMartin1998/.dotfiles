#!/bin/zsh

source ./util_lib.sh

# Create a lock dir for our current configs.
((latest_lock=$(get_latest_lock) + 1))
lock_dir="$LOCK_ROOT"/"$latest_lock"
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
        # mv "$final"/* "$lock_dest"
        mv "$final" "$lock_dest"
        echo "Moved \"$final\" to \"$lock_dest\""
    fi

    # Create destination directory
    mkdir -p "$dest"

    # Copy source to destination
    cp -r "$src" "$dest"
done
