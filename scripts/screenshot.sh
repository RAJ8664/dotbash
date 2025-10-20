#!/bin/bash
# Portable screenshot script for Linux
# Works with standard tools (ImageMagick 'import', maim) and optional notifications

# Variables
TIME=$(date "+%d-%b_%H-%M-%S")
DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"
FILE="Screenshot_$TIME.png"

NOTIFY() {
    # Notify if notify-send exists
    command -v notify-send >/dev/null 2>&1 && notify-send "Screenshot" "$1"
}

shot_now() {
    if command -v grim >/dev/null 2>&1; then
        grim "$DIR/$FILE"
    elif command -v maim >/dev/null 2>&1; then
        maim "$DIR/$FILE"
    elif command -v import >/dev/null 2>&1; then
        import -window root "$DIR/$FILE"
    else
        echo "❌ No screenshot tool found (grim, maim, or import)."
        exit 1
    fi
    NOTIFY "Saved: $DIR/$FILE"
}

shot_area() {
    if command -v slurp >/dev/null 2>&1 && command -v grim >/dev/null 2>&1; then
        AREA=$(slurp)
        grim -g "$AREA" "$DIR/$FILE"
    elif command -v maim >/dev/null 2>&1; then
        maim -s "$DIR/$FILE"
    else
        echo "❌ Area selection requires 'slurp' (Wayland) or 'maim -s' (X11)."
        exit 1
    fi
    NOTIFY "Saved area: $DIR/$FILE"
}

shot_window() {
    if command -v xwininfo >/dev/null 2>&1 && command -v import >/dev/null 2>&1; then
        WIN_ID=$(xwininfo | grep "Window id:" | awk '{print $4}')
        import -window "$WIN_ID" "$DIR/$FILE"
    else
        echo "❌ Window screenshot requires 'xwininfo' + 'import' (ImageMagick)."
        exit 1
    fi
    NOTIFY "Saved window: $DIR/$FILE"
}

case "$1" in
--now) shot_now ;;
--area) shot_area ;;
--win) shot_window ;;
*)
    echo "Usage: $0 [--now|--area|--win]"
    exit 1
    ;;
esac
