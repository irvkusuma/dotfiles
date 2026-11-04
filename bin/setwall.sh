#!/usr/bin/env bash

WALLDIR="$HOME/Pictures/Wallpapers"

if [ -n "$1" ]; then
    WALL="$1"
else
    # Format baris rofi: nama\0icon\x1fpath-gambar
CHOICE=$(find "$WALLDIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) -printf '%P\n' | sort | \
    while read -r f; do
        printf '%s\0icon\x1f%s\n' "$f" "$WALLDIR/$f"
    done | rofi -dmenu -i -p "󰸉 Wallpaper" -show-icons -theme ~/.config/rofi/wallpicker.rasi)
    [ -z "$CHOICE" ] && exit 0
    WALL="$WALLDIR/$CHOICE"
fi

plasma-apply-wallpaperimage "$WALL"
wallust run "$WALL"

plasma-apply-colorscheme BreezeDark >/dev/null 2>&1
plasma-apply-colorscheme Wallust >/dev/null 2>&1
pkill -USR1 kitty 2>/dev/null
