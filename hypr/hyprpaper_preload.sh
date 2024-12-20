monitor="DP-1"
wallpaper_dir="$HOME/.config/wallpapers/catppuccin"
wallpapers=$(find "$wallpaper_dir" -type f | sort -R)

for wallpaper in $wallpapers; do
    preload_string+="preload = "$wallpaper"\n"
    wallpaper_string+="wallpaper = $monitor, $wallpaper\n"
done

echo -en "$preload_string$wallpaper_string\nsplash=false" > ~/.config/hypr/hyprpaper.conf
