#!/usr/bin/env bash

# Toggle: tekan lagi untuk menutup
pgrep -x rofi >/dev/null && { pkill -x rofi; exit 0; }

THEME="$HOME/.config/rofi/powermenu.rasi"

# Satu pilihan = ikon besar + label kecil di bawahnya (markup pango)
entry() { printf '<span size="30pt">%s</span>\n<span size="11pt">%s</span>' "$1" "$2"; }

uptime_text=$(uptime -p | sed 's/^up //')

# Konfirmasi untuk aksi yang menutup sesi atau mematikan sistem
confirm() {
    local answer
    answer=$(printf '%s|%s' "$(entry 󰄬 Ya)" "$(entry 󰜺 Batal)" | \
        rofi -dmenu -sep '|' -markup-rows -format i \
            -mesg "$1?" \
            -theme "$THEME" \
            -theme-str 'window {width: 360px;} listview {columns: 2;}')
    [ "$answer" = "0" ]
}

# -sep '|' memisahkan pilihan dengan tanda |, sehingga tiap pilihan boleh berisi dua baris
choice=$(printf '%s|%s|%s|%s' \
    "$(entry 󰤄 Suspend)" \
    "$(entry 󰍃 Logout)" \
    "$(entry 󰜉 Restart)" \
    "$(entry 󰐥 Shutdown)" | \
    rofi -dmenu -sep '|' -markup-rows -format i \
        -mesg "Uptime: $uptime_text" \
        -theme "$THEME")

case "$choice" in
    0) systemctl suspend ;;
    1) confirm "Logout"   && hyprctl dispatch "hl.dsp.exit()" ;;
    2) confirm "Restart"  && systemctl reboot ;;
    3) confirm "Shutdown" && systemctl poweroff ;;
esac
