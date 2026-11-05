#!/usr/bin/env bash

# Toggle: tekan lagi untuk menutup
pgrep -x rofi >/dev/null && { pkill -x rofi; exit 0; }

THEME="$HOME/.config/rofi/powermenu.rasi"

entry() { printf '%s  %s' "$1" "$2"; }

uptime_text=$(uptime -p | sed 's/^up //')

# Konfirmasi untuk aksi yang menutup sesi atau mematikan sistem
confirm() {
    local answer
    answer=$(printf '%s\n%s\n' "$(entry 󰄬 Ya)" "$(entry 󰜺 Batal)" | \
        rofi -dmenu -i -format i \
            -mesg "$1?" \
            -theme "$THEME" \
            -theme-str 'window {width: 30%;} listview {columns: 2;}')
    [ "$answer" = "0" ]
}

choice=$(printf '%s\n%s\n%s\n%s\n' \
    "$(entry 󰤄 Suspend)" \
    "$(entry 󰍃 Logout)" \
    "$(entry 󰜉 Restart)" \
    "$(entry 󰐥 Shutdown)" | \
    rofi -dmenu -i -format i \
        -mesg "Uptime: $uptime_text" \
        -theme "$THEME")

case "$choice" in
    0) systemctl suspend ;;
    1) confirm "Logout"   && hyprctl dispatch "hl.dsp.exit()" ;;
    2) confirm "Restart"  && systemctl reboot ;;
    3) confirm "Shutdown" && systemctl poweroff ;;
esac
