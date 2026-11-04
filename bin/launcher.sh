#!/usr/bin/env bash
pgrep -x rofi >/dev/null && { pkill -x rofi; exit 0; }   # toggle: tekan lagi untuk menutup
rofi -show drun -theme ~/.config/rofi/launcher.rasi
