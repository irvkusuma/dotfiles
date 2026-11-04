#!/usr/bin/env bash
set -e

DEST="$HOME/dotfiles"
mkdir -p "$DEST"/{bin,wallust,rofi}

cp ~/.local/bin/setwall.sh ~/.local/bin/launcher.sh "$DEST/bin/"
cp ~/.config/wallust/wallust.toml "$DEST/wallust/"
cp -r ~/.config/wallust/templates "$DEST/wallust/"
cp ~/.config/rofi/{config,launcher,wallpicker}.rasi "$DEST/rofi/"

cd "$DEST"
[ -d .git ] || git init -q
git add -A
git commit -qm "Backup $(date +%F-%H%M)" && echo "Backup tersimpan di $DEST" || echo "Tidak ada perubahan"
