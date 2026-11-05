#!/usr/bin/env bash
set -e

DEST="$HOME/dotfiles"
mkdir -p "$DEST"/{bin,wallust/templates,rofi,waybar,hypr}

# Script
for f in setwall.sh launcher.sh powermenu.sh backup-rice.sh restore-rice.sh; do
    [ -f "$HOME/.local/bin/$f" ] && cp "$HOME/.local/bin/$f" "$DEST/bin/"
done

# wallust
cp ~/.config/wallust/wallust.toml "$DEST/wallust/"
cp -r ~/.config/wallust/templates/. "$DEST/wallust/templates/"

# rofi (colors.rasi sengaja tidak ikut karena dihasilkan wallust)
for f in config launcher wallpicker powermenu; do
    [ -f "$HOME/.config/rofi/$f.rasi" ] && cp "$HOME/.config/rofi/$f.rasi" "$DEST/rofi/"
done

# waybar (colors.css tidak ikut)
cp ~/.config/waybar/config.jsonc ~/.config/waybar/style.css "$DEST/waybar/"

# hyprland
cp ~/.config/hypr/hyprland.lua "$DEST/hypr/"

cd "$DEST"
[ -d .git ] || git init -q
git add -A
if git diff --cached --quiet; then
    echo "Tidak ada perubahan"
else
    git commit -qm "Backup $(date +%F-%H%M)"
    echo "Backup tersimpan di $DEST"
fi
