#!/usr/bin/env bash
set -e
SRC="$(cd "$(dirname "$0")" && pwd)"

mkdir -p ~/.local/bin ~/.config/wallust ~/.config/rofi

cp "$SRC"/bin/* ~/.local/bin/
chmod +x ~/.local/bin/setwall ~/.local/bin/launcher
cp "$SRC"/wallust/wallust.toml ~/.config/wallust/
cp -r "$SRC"/wallust/templates ~/.config/wallust/
cp "$SRC"/rofi/*.rasi ~/.config/rofi/

echo "Selesai. Jalankan 'setwall' untuk generate file warna."
