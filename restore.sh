#!/bin/zsh

source ./util_lib.sh

latest_lock=$(get_latest_lock)
has_lock=$(has_lock $latest_lock)

if [ $has_lock -eq 0 ]; then
    echo "No lock exists, nothing to restore."
    exit 0
fi

lock_dir="$LOCK_ROOT"/"$latest_lock"

# Iterate through the array of key-value pairs
for mapping in "${mappings[@]}"; do
    current_mapping=("${(@s:|:)mapping}")

    src="$lock_dir/$(basename "${current_mapping[1]}")"
    dest="${current_mapping[2]}"

    # If src exists at all? No matter if it's a file or directory
    if [ ! -e "$src" ]; then
        echo "$src does not exist, skipping."
        continue
    fi

    # Remove destination if it is a directory
    if [ -d "$src" ] && [ -d "$dest/${current_mapping[1]}" ]; then
        echo "Removing $dest/${current_mapping[1]}"
        rm -rf "$dest/${current_mapping[2]}"
    fi

    # Create destination directory
    mkdir -p "$dest"

    # Copy source to destination
    cp -r "$src" "$dest"
done
