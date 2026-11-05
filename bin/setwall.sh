#!/usr/bin/env bash

WALLDIR="$HOME/Pictures/Wallpapers"
DESKTOP="${XDG_CURRENT_DESKTOP,,}"   # huruf kecil

# Deteksi tambahan kalau XDG_CURRENT_DESKTOP kosong di Hyprland
[ -z "$DESKTOP" ] && [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ] && DESKTOP="hyprland"

notify() { command -v notify-send >/dev/null && notify-send "setwall" "$1"; echo "$1" >&2; }

# ---------- 1. Pilih wallpaper ----------
if [ "$1" = "--random" ]; then
    WALL=$(find "$WALLDIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) | shuf -n 1)
elif [ -n "$1" ]; then
    WALL="$1"
else
    CHOICE=$(find "$WALLDIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) -printf '%P\n' | sort | \
        while read -r f; do
            printf '%s\0icon\x1f%s\n' "$f" "$WALLDIR/$f"
        done | rofi -dmenu -i -p "󰸉 Wallpaper" -show-icons -theme ~/.config/rofi/wallpicker.rasi)
    [ -z "$CHOICE" ] && exit 0
    WALL="$WALLDIR/$CHOICE"
fi

[ -f "$WALL" ] || { notify "File tidak ditemukan: $WALL"; exit 1; }

# ---------- 2. Ganti wallpaper sesuai desktop ----------
set_wallpaper() {
    case "$DESKTOP" in
        *kde*)
            plasma-apply-wallpaperimage "$1" ;;
        *cosmic*)
            sed -i "s|Path(\"[^\"]*\")|Path(\"$1\")|" \
                "$HOME/.config/cosmic/com.system76.CosmicBackground/v1/all" ;;
        *gnome*)
            gsettings set org.gnome.desktop.background picture-uri "file://$1"
            gsettings set org.gnome.desktop.background picture-uri-dark "file://$1" ;;
	        *)
            # Hyprland, Niri, Mango, Sway, dll
            if command -v awww >/dev/null; then WP=awww
            elif command -v swww >/dev/null; then WP=swww
            else notify "Tidak ada awww/swww. Pasang awww dulu."; return 1
            fi
		if pgrep -f nwg-dock-hyprland >/dev/null; then
    pkill -f nwg-dock-hyprland
    setsid -f nwg-dock-hyprland -d -i 44 -mb 10 >/dev/null 2>&1
fi

            "$WP" img "$1" --transition-type random --transition-duration 1.2 --transition-fps 60 ;;
    esac
}

set_wallpaper "$WALL" || notify "Gagal mengganti wallpaper"

# ---------- 3. Generate palette ----------
wallust run "$WALL" || notify "wallust gagal"

# ---------- 4. Terapkan warna sesuai desktop ----------
case "$DESKTOP" in
    *kde*)
        plasma-apply-colorscheme BreezeDark >/dev/null 2>&1
        plasma-apply-colorscheme Wallust   >/dev/null 2>&1 ;;
esac

# ---------- 5. Reload aplikasi yang memakai palette ----------
pkill -SIGUSR2 waybar 2>/dev/null          # muat ulang style Waybar
pkill -USR1 kitty 2>/dev/null              # muat ulang warna kitty
if pgrep -x nwg-dock-hyprland >/dev/null; then
    pkill -x nwg-dock-hyprland
    setsid -f nwg-dock-hyprland -d -i 44 -mb 10 >/dev/null 2>&1
fi
